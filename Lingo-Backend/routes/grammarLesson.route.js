import express from "express";
import { getAllLessons } from "../controllers/grammarLesson.controller.js";

const router = express.Router();

router.route("").get(getAllLessons);

export default router;
