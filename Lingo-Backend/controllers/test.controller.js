import { Test } from "../models/test.model.js";
import { TestAttempt } from "../models/testAttemptsData.model.js";


export const getAllTests = async (_, res) => {
  try {
    const tests = await Test.find();
    if (tests.length == 0) {
      throw new Error("No tests available");
    }
    return res.status(200).json({
      availableTests: tests,
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      message: "Unable to get all lessons!",
      success: false,
      error: error,
    });
  }
};

export const getTestById = async (req, res) => {
  try {
    const testId = req.params.id;  // assuming test ID is passed as a URL param

    // Find the test by ID
    const test = await Test.findById(testId);

    if (!test) {
      return res.status(404).json({ message: "Test not found" });
    }

    res.status(200).json({ test });
  } catch (error) {
    console.error("Error fetching test:", error);
    res.status(500).json({ message: "Internal server error" });
  }
};


export const getAllTestsWithAttemptStatus = async (req, res) => {
  try {
    const userId = req.id;

    // 1. Fetch all tests with needed fields
    const tests = await Test.find({}, "title description");

    if (tests.length === 0) {
      throw new Error("No tests available");
    }

    // 2. Fetch all attempts by this user
    const attempts = await TestAttempt.find({ userId }).select("testId");

    // Create a Set of attempted test IDs for quick lookup
    const attemptedTestIds = new Set(attempts.map(attempt => attempt.testId.toString()));

    // 3. Map attempt status to each test
    const testsWithStatus = tests.map(test => ({
      id: test._id,
      title: test.title,
      description: test.description,
      attempted: attemptedTestIds.has(test._id.toString()),
    }));

    res.status(200).json({ availableTests: testsWithStatus });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      message: "Unable to get all tests with attempt status!",
      success: false,
      error: error.message,
    });
  }
};



export const createTest = async (req, res) => {
  try {
    const { title, description, questions } = req.body;

    if (!title || !questions || questions.length === 0) {
      return res.status(400).json({ message: "Title and questions are required" });
    }

    const newTest = new Test({ title, description, questions });
    await newTest.save();

    res.status(201).json({ message: "Test created successfully", test: newTest });
  } catch (error) {
    console.error("Error creating test:", error);
    res.status(500).json({ message: "Internal server error" });
  }
};



export const submitTestAttempt = async (req, res) => {
  try {
    const userId = req.id;
    const { testId, answers } = req.body;

    const test = await Test.findById(testId);
    if (!test) return res.status(404).json({ message: "Test not found" });

    let score = 0;
    const processedAnswers = answers.map(({ questionId, selectedAnswer }) => {
      const question = test.questions.find(
        q => q._id.toString() === questionId
      );

      const isCorrect = question?.correctAnswer === selectedAnswer;
      if (isCorrect) score++;

      return {
        questionId,
        selectedAnswer,
        isCorrect
      };
    });

    const attempt = new TestAttempt({
      userId,
      testId,
      answers: processedAnswers,
      score
    });

    await attempt.save();

    res.status(200).json({
      message: "Test attempt recorded successfully",
      score,
      totalQuestions: test.questions.length
    });
  } catch (error) {
    console.error("Error saving test attempt:", error);
    res.status(500).json({ message: "Internal server error" });
  }
};


export const getTestReportsByUser = async (req, res) => {
  try {
    const userId = req.id; // Assuming this is set via auth middleware

    // 1. Find all attempts by the user and populate test details
    const attempts = await TestAttempt.find({ userId })
      .populate("testId", "title") // Only bring the test title
      .sort({ attemptedAt: -1 });  // Optional: latest first

    if (attempts.length === 0) {
      return res.status(404).json({ message: "No test attempts found for this user." });
    }

    // 2. Build report for each attempt
    const reports = attempts.map(attempt => {
      const correct = attempt.answers.filter(ans => ans.isCorrect).length;
      const incorrect = attempt.answers.length - correct;

      return {
        testTitle: attempt.testId.title,
        attemptedAt: attempt.attemptedAt,
        score: attempt.score,
        correct,
        incorrect
      };
    });

    return res.status(200).json({ testReports: reports });
  } catch (error) {
    console.error("Error fetching test reports:", error);
    res.status(500).json({ message: "Internal server error" });
  }
};


export const getTestReportByTestId = async (req, res) => {
  try {
    const userId = req.id; // From auth middleware
    const {testId}  = req.params;

    // 1. Find the user's attempt for the test
    const attempt = await TestAttempt.findOne({ userId, testId });

    if (!attempt) {
      return res.status(404).json({ message: "No attempt found for this test." });
    }

    // 2. Fetch the original test with questions
    const test = await Test.findById(testId).select("title questions");

    if (!test) {
      return res.status(404).json({ message: "Test not found." });
    }

    // 3. Map the attempt answers to questions
    const report = test.questions.map(question => {
      const userAnswer = attempt.answers.find(
        ans => ans.questionId.toString() === question._id.toString()
      );

      return {
        questionText: question.questionText,
        options: question.options,
        correctAnswer: question.correctAnswer,
        selectedAnswer: userAnswer ? userAnswer.selectedAnswer : null,
        isCorrect: userAnswer ? userAnswer.isCorrect : false
      };
    });

    // 4. Include test title and overall score
    res.status(200).json({
      testTitle: test.title,
      score: attempt.score,
      attemptedAt: attempt.attemptedAt,
      totalQuestions: report.length,
      correctAnswers: report.filter(q => q.isCorrect).length,
      questions: report
    });
  } catch (error) {
    console.error("Error fetching detailed test report:", error);
    res.status(500).json({ message: "Internal server error" });
  }
};



