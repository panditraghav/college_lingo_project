import mongoose from "mongoose";

const grammarProgressSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  completedLessons: [
    {
      lessonId: { type: mongoose.Schema.Types.ObjectId, ref: "GrammarLesson" },
      completedAt: Date,
    },
  ],
  quizResults: [
    {
      quizId: { type: mongoose.Schema.Types.ObjectId, ref: "GrammarQuiz" },
      score: Number,
      total: Number,
      submittedAt: Date,
    },
  ],
});

export const grammarProgress = mongoose.model(
  "GrammarProgress",
  grammarProgressSchema,
);
