import {corsHandler, API_KEY} from "./utils/corsAndApiKey";
import * as functions from "firebase-functions";
import axios from "axios";

const BASE_URL = "https://api.steampowered.com";
const PLAYER_ACHIEVEMENTS_ENDPOINT
    = "/ISteamUserStats/GetPlayerAchievements/v0001/";

const getPlayerAchievements = async (steamid: string, appid: string) => {
  const response = await axios.get(`${BASE_URL}${PLAYER_ACHIEVEMENTS_ENDPOINT}`, {
    params: {steamid, appid, key: API_KEY},
  });
  return response.data;
};

export const getPlayerAchievementsFunction = functions.https.onRequest((req, res) => {
  corsHandler(req, res, async () => {
    const {steamid, appid} = req.query;
    if (!steamid || !appid) {
      return res.status(400).send("Missing steamid or appid parameter");
    }

    try {
      const playerAchievements = await getPlayerAchievements(steamid as string, appid as string);
      return res.status(200).json(playerAchievements);
    } catch (error) {
      return res.status(500).send("Error fetching player achievements from Steam API");
    }
  });
});
