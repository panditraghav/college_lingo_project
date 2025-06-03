import mongoose from "mongoose";

const chatHistorySchema = new mongoose.Schema(
  {
    chat: [
      {
        role: String,
        message: String,
        audio: String,
      },
    ],
  },
  { timestamps: true },
);

export const ChatHistory = mongoose.model("ChatHistory", chatHistorySchema);
