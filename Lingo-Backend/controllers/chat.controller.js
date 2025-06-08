import { ChatHistory } from "../models/chatHistory.model.js";

export const getAllChat = async (req, res) => {
  try {
    const userId = req.params.userId;

    if (userId == undefined) {
      throw new Error("userId not provided in params");
    }
    const chats = await ChatHistory.find({ userId: userId }).sort({
      updatedAt: -1,
    });
    if (chats.length == 0) {
      throw new Error("No chats available");
    }
    return res.status(200).json(chats);
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      message: "Unable to get all chats!",
      success: false,
      error: error,
    });
  }
};

export const getChat = async (req, res) => {
  try {
    const chatId = req.params.id;
    const chat = await ChatHistory.findById(chatId);

    if (!chat) {
      return res.status(404).json({
        message: "Chat not found!",
        success: false,
      });
    }
    return res.status(200).json(chat);
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      message: "Unable to get all chats!",
      success: false,
      error: error,
    });
  }
};

export const createChat = async (req, res) => {
  try {
    console.log("/new/:userId");
    const { userId } = req.params;
    console.log({ userId });
    if (userId == undefined) {
      return res.status(400).json({
        message: "userId not provided!",
        success: false,
      });
    }
    const chat = await ChatHistory.create({ chat: [], userId });
    return res.status(200).json(chat);
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      message: "Unable to create chat!",
      success: false,
      error: error,
    });
  }
};

export const updateChat = async (req, res) => {
  try {
    const chatId = req.params.chatId;
    if (!chatId) {
      return res.status(400).json({
        message: "Bad requrest, missing chatId",
        success: false,
      });
    }

    const { role, message, audio } = req.body;
    if (!role || !message) {
      return res.status(400).json({
        message: "Bad requrest, missing body",
        success: false,
      });
    }
    const chat = await ChatHistory.findById(chatId);
    if (!chat) {
      return res.status(404).json({
        message: "Chat not found!",
        success: false,
      });
    }
    const newChats = [...chat.chat, { role, message, audio }];
    const result = await ChatHistory.updateOne(
      { _id: chat.id },
      { chat: newChats },
    );

    if (result.matchedCount == 0) {
      return res.status(404).json({
        message: "Unable to update chat",
        success: false,
      });
    }

    return res.json({ message: "Chat updated!", success: true });
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      message: "Unable to update chat!",
      success: false,
      error: error,
    });
  }
};
