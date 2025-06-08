import express from "express"
import isAuthenticated from "../middlewares/isAuthenticated.js";
import { createTest, getAllTests, getAllTestsWithAttemptStatus, getTestById, getTestReportByTestId, getTestReportsByUser, submitTestAttempt } from "../controllers/test.controller.js";


const router = express.Router();


router.route("/post").post(isAuthenticated,createTest);
router.route("/submit").post(isAuthenticated,submitTestAttempt);
router.route("/getalltests").get(isAuthenticated,getAllTests);
router.route("/get").get(isAuthenticated,getAllTestsWithAttemptStatus);
router.route("/getsingletest/:id").get(isAuthenticated,getTestById);
router.route("/getreport").get(isAuthenticated,getTestReportsByUser);
router.route("/gettestresult/:testId").get(isAuthenticated,getTestReportByTestId);

export default router;
