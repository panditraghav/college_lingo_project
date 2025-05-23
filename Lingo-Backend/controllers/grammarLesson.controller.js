import { GrammarLesson } from "../models/grammarLesson.model.js";

export const getAllLessons = async (_, res) => {
  try {
    const lessons = await GrammarLesson.find();
    if (lessons.length == 0) {
      throw new Error("No lessons available");
    }
    return res.status(200).json({
      grammarLesson: lessons,
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
