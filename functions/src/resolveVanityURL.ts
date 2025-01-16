import {corsHandler, API_KEY} from "./utils/corsAndApiKey";
import * as functions from "firebase-functions";
import axios from "axios";

const BASE_URL = "https://api.steampowered.com";
const RESOLVE_VANITY_URL_ENDPOINT = "/ISteamUser/ResolveVanityURL/v1/";

const resolveVanityURL = async (vanityurl: string) => {
  const response = await axios.get(`${BASE_URL}${RESOLVE_VANITY_URL_ENDPOINT}`, {
    params: {vanityurl, key: API_KEY},
  });
  return response.data;
};

export const resolveVanityURLFunction = functions.https.onRequest((req, res) => {
  corsHandler(req, res, async () => {
    const {vanityurl} = req.query;
    if (!vanityurl) {
      return res.status(400).send("Missing vanityurl parameter");
    }

    try {
      const vanityURLData = await resolveVanityURL(vanityurl as string);
      return res.status(200).json(vanityURLData);
    } catch (error) {
      return res.status(500).send("Error resolving vanity URL from Steam API");
    }
  });
});
