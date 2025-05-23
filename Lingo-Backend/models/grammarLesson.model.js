import mongoose from "mongoose";

const grammarLessonSchema = new mongoose.Schema({
  title: String,
  index: Number,
  subtopics: [
    {
      title: String,
      content: String, // Markdown/HTML content
    },
  ],
});

export const GrammarLesson = mongoose.model(
  "GrammarLesson",
  grammarLessonSchema,
);
