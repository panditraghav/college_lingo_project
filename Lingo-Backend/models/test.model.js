// models/test.model.js
import mongoose from "mongoose";

const questionSchema = new mongoose.Schema({
  questionText: {
    type: String,
    required: true,
  },
  options: [
    {
      type: String,
      required: true,
    }
  ],
  correctAnswer: {
    type: String, 
    required: true,
  }
});

const testSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true,
  },
  description: String,
  questions: [questionSchema]
});

export const Test = mongoose.model("Test", testSchema);
