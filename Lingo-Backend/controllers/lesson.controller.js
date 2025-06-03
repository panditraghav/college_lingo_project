import { Lesson } from "../models/lesson.model.js";
import { User } from "../models/user.model.js"

export const getAllLessons = async (_, res) => {
  try {
    const lessons = await Lesson.find();
    if (lessons.length == 0) {
      throw new Error("No lessons available");
    }
    return res.status(200).json({
      grammarLesson: lessons,
      success: true
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

export const getLessonById = async (req, res) => {
  try {
    const { lessonId } = req.params;
    console.log(lessonId);

    const lesson1 = await Lesson.findById(lessonId).lean(); 

    if (!lesson1) {
      return res.status(404).json({
        message: "Lesson not found",
        success: false
      });
    }

    return res.status(200).json({
      lesson: lesson1,
      success: true
    });

  } catch (error) {
    console.error("Error in getLessonById:", error);
    return res.status(500).json({
      message: "Unable to get the lesson!",
      success: false,
      error: error.message
    });
  }
};


export const getBeginnerLessons = async (req, res) => {
  try {
    const userId = req.id;

    // 1. Get all beginner lessons
    const beginnerLessons = await Lesson.find({ level: "Beginner" }).sort({ index: 1 });

    // 2. Get user's lesson progress
    const user = await User.findById(userId).select("lessonProgress");

    // 3. Map status into each lesson
    const lessonsWithStatus = beginnerLessons.map(lesson => {
      const progress = user.lessonProgress.find(p => p.lessonId.toString() === lesson._id.toString());
      return {
        ...lesson.toObject(),
        status: progress ? progress.status : "Pending"
      };
    });

    res.status(200).json({beginnerLessons:lessonsWithStatus, success: true,});
  } catch (error) {
    console.error("Error fetching beginner lessons with status:", error);
    res.status(500).json({ message: "Internal server error", success: false });
  }
};


export const getIntermediateLessons = async (req, res) => {
  try {
    const userId = req.id;

    // 1. Get all intermediate lessons
    const intermediateLessons = await Lesson.find({ level: "Intermediate" }).sort({ index: 1 });

    // 2. Get user's lesson progress
    const user = await User.findById(userId).select("lessonProgress");

    // 3. Map status into each lesson
    const lessonsWithStatus = intermediateLessons.map(lesson => {
      const progress = user.lessonProgress.find(p => p.lessonId.toString() === lesson._id.toString());
      return {
        ...lesson.toObject(),
        status: progress ? progress.status : "Pending"
      };
    });

    res.status(200).json({intermediateLessons:lessonsWithStatus, success: true});
  } catch (error) {
    console.error("Error fetching intermediate lessons with status:", error);
    res.status(500).json({ message: "Internal server error", success: false });
  }
};

export const getAdvancedLessons = async (req, res) => {
  try {
    const userId = req.id;

    // 1. Get all advanced lessons
    const advancedLessons = await Lesson.find({ level: "Advanced" }).sort({ index: 1 });

    // 2. Get user's lesson progress
    const user = await User.findById(userId).select("lessonProgress");

    // 3. Map status into each lesson
    const lessonsWithStatus = advancedLessons.map(lesson => {
      const progress = user.lessonProgress.find(p => p.lessonId.toString() === lesson._id.toString());
      return {
        ...lesson.toObject(),
        status: progress ? progress.status : "Pending"
      };
    });

    res.status(200).json({advancedLesson: lessonsWithStatus, success:true});
  } catch (error) {
    console.error("Error fetching advanced lessons with status:", error);
    res.status(500).json({ message: "Internal server error", success: false });
  }
};


export const postLesson = async (req, res) => {
  try {
    const { index, level, title, description, content } = req.body;

    if (!index || !level || !title || !description || !content) {
      return res.status(400).json({ error: "All fields are required." });
    }

    const newLesson = new Lesson({
      index,
      level,
      title,
      description,
      content,
    });

    const savedLesson = await newLesson.save();
    res.status(200).json({ message: "Lesson created successfully", lesson: savedLesson, success:true});
  } catch (err) {
    console.error("Error creating lesson:", err);
    res.status(500).json({ error: "Internal Server Error", success: false });
  }
};


export const updateLessonStatus = async (req, res) => {
  try {
    const userId = req.id;
    const lessonId = req.params.id;


    const lessonExists = await Lesson.findById(lessonId);
    if (!lessonExists) {
      return res.status(404).json({ message: "Lesson not found" });
    }

    const user = await User.findById(userId);
    if (!user) return res.status(404).json({ message: "User not found" });


    const progress = user.lessonProgress.find(progress =>
      progress.lessonId.toString() === lessonId
    );

    if (progress) {
      // Already exists – update status
      progress.status = "Completed";
    } else {
      // Doesn't exist – add new progress
      user.lessonProgress.push({ lessonId, status: "Completed" });
    }

    await user.save();
    res.status(200).json({ message: "Lesson marked as completed", success:true });
  } catch (error) {
    console.error("Error completing lesson:", error);
    res.status(500).json({ message: "Internal server error",success:false });
  }
};



