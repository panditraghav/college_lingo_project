import mongoose from "mongoose";

const testAttemptSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true
  },
  testId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Test",
    required: true
  },
  answers: [
    {
      questionId: {
        type: mongoose.Schema.Types.ObjectId,
        required: true,
      },
      selectedAnswer: {
        type: String, 
        required: true,
      },
      isCorrect: {
        type: Boolean,
        required: true
      }
    }
  ],
  score: {
    type: Number,
    required: true
  },
  attemptedAt: {
    type: Date,
    default: Date.now
  }
});

export const TestAttempt = mongoose.model("TestAttempt", testAttemptSchema);
