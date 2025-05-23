import { GrammarLesson } from "../models/grammarLesson.model.js";
import mongoose from "mongoose";
import dotenv from "dotenv";
dotenv.config({});

const grammarLessons = [
  {
    title: "Parts of Speech",
    index: 1,
    subtopics: [
      {
        title: "Nouns",
        content:
          "Nouns are words that name people, places, things, or ideas. Example: _cat_, _city_, _happiness_.",
      },
      {
        title: "Verbs",
        content:
          "Verbs show actions or states of being. Example: _run_, _think_, _is_.",
      },
      {
        title: "Adjectives",
        content:
          "Adjectives describe nouns. Example: _blue car_, _happy child_.",
      },
    ],
  },
  {
    title: "Tenses Overview",
    index: 2,
    subtopics: [
      {
        title: "Present Simple",
        content:
          "Used for regular actions. Example: _She walks to school every day._",
      },
      {
        title: "Past Simple",
        content:
          "Describes actions completed in the past. Example: _He played football yesterday._",
      },
      {
        title: "Future Simple",
        content:
          "Used for actions that will happen. Example: _They will visit tomorrow._",
      },
    ],
  },
  {
    title: "Subject-Verb Agreement",
    index: 3,
    subtopics: [
      {
        title: "Basic Rules",
        content:
          "Singular subjects take singular verbs. Example: _The dog barks._",
      },
      {
        title: "With Indefinite Pronouns",
        content:
          "Everyone, each, someone — use singular verbs. Example: _Everyone is happy._",
      },
    ],
  },
  {
    title: "Articles",
    index: 4,
    subtopics: [
      {
        title: "Definite Article",
        content:
          "`The` is used to refer to a specific noun. Example: _The sun is bright._",
      },
      {
        title: "Indefinite Articles",
        content:
          "`A` and `An` refer to non-specific nouns. Example: _A book_, _An apple_.",
      },
    ],
  },
  {
    title: "Prepositions",
    index: 5,
    subtopics: [
      {
        title: "Time Prepositions",
        content:
          "`At`, `on`, and `in` are used with time expressions. Example: _on Monday_, _at 5 PM_, _in June_.",
      },
      {
        title: "Place Prepositions",
        content:
          "Used to show location. Example: _in the room_, _on the table_, _under the bed_.",
      },
    ],
  },
  {
    title: "Modal Verbs",
    index: 6,
    subtopics: [
      {
        title: "Common Modals",
        content:
          "Can, could, may, might, must, shall, should, will, would. Example: _You must study._",
      },
      {
        title: "Modals of Possibility",
        content: "Example: _She might come later._",
      },
    ],
  },
  {
    title: "Conditionals",
    index: 7,
    subtopics: [
      {
        title: "Zero Conditional",
        content: "General truths. _If you heat ice, it melts._",
      },
      {
        title: "First Conditional",
        content:
          "Real future possibility. _If it rains, we will cancel the trip._",
      },
      {
        title: "Second Conditional",
        content: "Imaginary present/future. _If I had wings, I would fly._",
      },
    ],
  },
  {
    title: "Pronouns",
    index: 8,
    subtopics: [
      {
        title: "Personal Pronouns",
        content: "I, you, he, she, it, we, they. Example: _She is my friend._",
      },
      {
        title: "Possessive Pronouns",
        content:
          "Mine, yours, his, hers, ours, theirs. Example: _This book is mine._",
      },
    ],
  },
  {
    title: "Passive Voice",
    index: 9,
    subtopics: [
      {
        title: "Basic Structure",
        content:
          "Object + to be + past participle. Example: _The letter was written by John._",
      },
      {
        title: "When to Use",
        content:
          "Use when the focus is on the action or receiver. Example: _The cake was eaten._",
      },
    ],
  },
  {
    title: "Reported Speech",
    index: 10,
    subtopics: [
      {
        title: "Statements",
        content:
          "Change tense and pronouns. Example: _She said she was tired._",
      },
      {
        title: "Questions",
        content:
          "Use question words, change structure. Example: _He asked where I was going._",
      },
    ],
  },
];

const main = async () => {
  try {
    await mongoose.connect(process.env.MONGO_URI);
    console.log("mongodb connected successfully");
    const lessons = await GrammarLesson.find();
    if (lessons.length > 0) {
      console.log("Lessons already available!, not inserting!");
      return;
    }
    GrammarLesson.insertMany(grammarLessons)
      .then((doc) => {
        console.log("Grammar lessons inserted!");
        console.log(doc);
      })
      .catch((error) => {
        console.log(error);
      });
  } catch (error) {
    console.log(error);
  }
};
main()
  .then(() => {
    process.exit(0);
  })
  .catch(() => {
    process.exit(1);
  });
