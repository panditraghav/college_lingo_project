import express from "express";
import { getAllLessons, postLesson, updateLessonStatus, getBeginnerLessons, getIntermediateLessons, getAdvancedLessons, getLessonById } from "../controllers/lesson.controller.js";
import isAuthenticated from "../middlewares/isAuthenticated.js";

const router = express.Router();

router.route("/get").get(isAuthenticated,getAllLessons);
router.route("/post").post(postLesson);
router.route("/update/:id").post(isAuthenticated,updateLessonStatus);
router.route("/getbeginnerlessons").get(isAuthenticated,getBeginnerLessons);
router.route("/getintermediatelessons").get(isAuthenticated,getIntermediateLessons);
router.route("/getadvancedlessons").get(isAuthenticated,getAdvancedLessons);
router.route("/getlesson/:lessonId").get(isAuthenticated,getLessonById);

export default router;
