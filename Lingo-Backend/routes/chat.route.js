import express from "express";
import {
  createChat,
  getAllChat,
  getChat,
  updateChat,
} from "../controllers/chat.controller.js";

const router = express.Router();

router.route("/").get(getAllChat);
router.route("/new").get(createChat);
router.route("/:id").get(getChat);
router.route("/:id").put(updateChat);

export default router;
