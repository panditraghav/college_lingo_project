import mongoose from "mongoose";

const userSchema = new mongoose.Schema(
  {
    fullName: {
      type: String,
      required: true,
      trim: true
    },
    email: {
      type: String,
      required: true,
      unique: true,
      lowercase: true,
      trim: true
    },
    password: {
      type: String,
      required: true,
    },
    age: {
      type: Number,
      min: 0
    },
    gender: {
      type: String,
      lowercase: true,
      enum: ['male', 'female']
    },
    profilePhoto: {
      type: String
    },
    dateOfBirth: {
      type: Date
    },
    phoneNumber: {
      type: String,
      trim: true
    },
    lessonProgress: [{
      lessonId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Lesson"
      },
      status: {
        type: String,
        enum: ["Completed", "Pending"],
        default: "Pending"
      }
    }]
  },
  {
    timestamps: true
  }
);

export const User = mongoose.model("User", userSchema);

