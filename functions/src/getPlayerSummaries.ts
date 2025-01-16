import { corsHandler, API_KEY } from "./utils/corsAndApiKey";
import * as functions from "firebase-functions";
import axios from "axios";

const BASE_URL = "https://api.steampowered.com";
const PLAYER_SUMMARIES_ENDPOINT = "/ISteamUser/GetPlayerSummaries/v0002/";

const getPlayerSummaries = async (steamids: string) => {
  const response = await axios.get(`${BASE_URL}${PLAYER_SUMMARIES_ENDPOINT}`, {
    params: { steamids, key: API_KEY },
  });
  return response.data;
};

export const getPlayerSummariesFunction = functions.https.onRequest((req, res) => {
  corsHandler(req, res, async () => {
    console.log("getPlayerSummariesFunction, $req");
    const { steamids } = req.query;
    if (!steamids) {
      return res.status(400).send("Missing steamids parameter"); // 명시적으로 반환
    }

    try {
      const playerSummaries = await getPlayerSummaries(steamids as string);
      return res.status(200).json(playerSummaries); // 명시적으로 반환
    } catch (error) {
      return res.status(500).send("Error fetching data from Steam API"); // 명시적으로 반환
    }
  });
});
