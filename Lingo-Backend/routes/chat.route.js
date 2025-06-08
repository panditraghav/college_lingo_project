import express from "express";
import {
  createChat,
  getAllChat,
  getChat,
  updateChat,
} from "../controllers/chat.controller.js";

const router = express.Router();

router.route("/new/:userId").get(createChat);
router.route("/update/:chatId").put(updateChat);
router.route("/from-user/:userId").get(getAllChat);
router.route("single/:id").get(getChat);

export default router;
