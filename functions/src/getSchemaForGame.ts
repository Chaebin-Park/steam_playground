import {corsHandler, API_KEY} from "./utils/corsAndApiKey";
import * as functions from "firebase-functions";
import axios from "axios";

const BASE_URL = "https://api.steampowered.com";
const SCHEMA_FOR_GAME_ENDPOINT = "/ISteamUserStats/GetSchemaForGame/v2/";

const getSchemaForGame = async (appid: string) => {
  const response = await axios.get(`${BASE_URL}${SCHEMA_FOR_GAME_ENDPOINT}`, {
    params: {appid, key: API_KEY},
  });
  return response.data;
};

export const getSchemaForGameFunction = functions.https.onRequest((req, res) => {
  corsHandler(req, res, async () => {
    const {appid} = req.query;
    if (!appid) {
      return res.status(400).send("Missing appid parameter");
    }

    try {
      const schemaForGameData = await getSchemaForGame(appid as string);
      return res.status(200).json(schemaForGameData);
    } catch (error) {
      return res.status(500).send("Error fetching schema for game from Steam API");
    }
  });
});
