import mongoose from "mongoose"

const lessonSchema = new mongoose.Schema({
  index: {
    type: Number,
    required: true,
  },
  level: {
    type: String,
    enum: ['Beginner', 'Intermediate', 'Advanced'],
    required: true,
  },
  title: {
    type: String,
    required: true,
    trim: true,
  },
  description: {
    type: String,
    required: true,
    trim: true,
  },
  content: {
    type: [String],
    required: true,
  }
},
  {
    timestamps: true
  });

export const Lesson = mongoose.model('Lesson', lessonSchema);


