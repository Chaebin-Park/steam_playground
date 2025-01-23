import {onRequest} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import * as functions from "firebase-functions/v2";
import axios from "axios";
import cors from "cors";

// CORS 처리
export const corsHandler = cors({origin: true});

export const helloWorld = onRequest((request, response) => {
  logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});

export const API_KEY = process.env.STEAM_API_KEY;
// export const API_KEY = functions.config().steam.apikey;
const BASE_URL = "https://api.steampowered.com";
const PLAYER_SUMMARIES_ENDPOINT = "/ISteamUser/GetPlayerSummaries/v0002/";

const getPlayerSummariesFunction = async (steamids: string) => {
  const response = await axios.get(`${BASE_URL}${PLAYER_SUMMARIES_ENDPOINT}`, {
    params: {steamids, key: API_KEY},
  });
  return response.data;
};

export const getPlayerSummaries = functions
  .https.onRequest((req, res) => {
    corsHandler(req, res, async () => {
      const {steamids} = req.query;
      if (!steamids) {
        return res.status(404).send("No steamids found.");
      }
      try {
        const playerSummaries = await getPlayerSummariesFunction(steamids as string);
        logger.info("player summaries!", {structuredData: true});
        return res.status(200).send(playerSummaries);
      } catch (error) {
        const errorMessage =
          `Error fetching player summaries from Steam API ${error}`;
        return res.status(500).send(errorMessage);
      }
    });
  });

const OWNED_GAMES_ENDPOINT = "/IPlayerService/GetOwnedGames/v0001/";

const getOwnedGamesFunction = async (steamid: string) => {
  const response =
    await axios.get(`${BASE_URL}${OWNED_GAMES_ENDPOINT}`, {
      params: {steamid, key: API_KEY},
    });
  return response.data;
};

export const getOwnedGames = functions
  .https.onRequest({
    timeoutSeconds: 120,
    memory: "1GiB",
  }, async (req, res) => {
    corsHandler(req, res, async () => {
      const {steamid} = req.query;
      if (!steamid) {
        return res.status(400).send("Missing steamid parameter");
      }
      try {
        const ownedGames = await getOwnedGamesFunction(steamid as string);
        return res.status(200).json(ownedGames);
      } catch (error) {
        const errorMessage = "Error fetching owned games from Steam API";
        return res.status(500).send(errorMessage);
      }
    });
  });

const RESOLVE_VANITY_URL_ENDPOINT = "/ISteamUser/ResolveVanityURL/v1/";

const resolveVanityURLFunction = async (vanityurl: string) => {
  const response =
    await axios.get(`${BASE_URL}${RESOLVE_VANITY_URL_ENDPOINT}`, {
      params: {vanityurl, key: API_KEY},
    });
  return response.data;
};

export const resolveVanityURL = functions
  .https.onRequest({
    timeoutSeconds: 120,
    memory: "1GiB",
  }, async (req, res) => {
    corsHandler(req, res, async () => {
      const {vanityurl} = req.query;
      if (!vanityurl) {
        return res.status(400).send("Missing vanityurl parameter");
      }

      try {
        const vanityURLData = await resolveVanityURLFunction(vanityurl as string);
        return res.status(200).json(vanityURLData);
      } catch (error) {
        const errorMessage =
          "Error resolving vanity URL from Steam API";
        return res.status(500).send(errorMessage);
      }
    });
  });

const PLAYER_ACHIEVEMENTS_ENDPOINT =
  "/ISteamUserStats/GetPlayerAchievements/v0001/";

const getPlayerAchievementsFunction = async (steamid: string, appid: string) => {
  const response =
    await axios.get(`${BASE_URL}${PLAYER_ACHIEVEMENTS_ENDPOINT}`, {
      params: {steamid, appid, key: API_KEY},
    });
  return response.data;
};

export const getPlayerAchievements = functions
  .https.onRequest({
    timeoutSeconds: 120,
    memory: "1GiB",
  }, async (req, res) => {
    corsHandler(req, res, async () => {
      const {steamid, appid} = req.query;
      if (!steamid || !appid) {
        return res.status(400).send("Missing steamid or appid parameter");
      }
      try {
        const playerAchievements =
          await getPlayerAchievementsFunction(steamid as string, appid as string);
        return res.status(200).json(playerAchievements);
      } catch (error) {
        const errorMessage =
          "Error fetching player achievements from Steam API";
        return res.status(500).send(errorMessage);
      }
    });
  });

const SCHEMA_FOR_GAME_ENDPOINT =
  "/ISteamUserStats/GetSchemaForGame/v2/";

const schemaForGameFunction = async (appid: string) => {
  const response =
    await axios.get(`${BASE_URL}${SCHEMA_FOR_GAME_ENDPOINT}`, {
      params: {appid, key: API_KEY},
    });
  return response.data;
};

export const schemaForGame = functions
  .https.onRequest({
    timeoutSeconds: 120,
    memory: "1GiB",
  }, async (req, res) => {
    corsHandler(req, res, async () => {
      const {appid} = req.query;
      if (!appid) {
        return res.status(400).send("Missing steamid or appid parameter");
      }
      try {
        const playerAchievements =
          await schemaForGameFunction(appid as string);
        return res.status(200).json(playerAchievements);
      } catch (error) {
        const errorMessage =
          "Error fetching player achievements from Steam API";
        return res.status(500).send(errorMessage);
      }
    });
  });
