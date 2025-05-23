import mongoose from "mongoose";

const grammarQuizSchema = new mongoose.Schema({
  title: String,
  lessonId: { type: mongoose.Schema.Types.ObjectId, ref: "GrammarLesson" },
  questions: [
    {
      question: String,
      options: [String],
      correctAnswerIndex: String,
    },
  ],
});

export default GrammarQuiz = mongoose.model("GrammarQuiz", grammarQuizSchema);
