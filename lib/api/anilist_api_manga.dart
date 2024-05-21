import 'dart:convert';
import 'package:unyo/models/models.dart';
import 'package:http/http.dart' as http;

const String anilistEndpoint = "https://graphql.anilist.co";
const String anilistEndPointGetToken =
    "https://anilist.co/api/v2/oauth/authorize?client_id=17550&response_type=token";

Future<List<MangaModel>> getMangaModelListTrending(
    int page, int n, int attempt) async {
  Map<String, dynamic> query = {
    "query":
        "query(\$page:Int \$id:Int \$type:MediaType \$isAdult:Boolean = false \$search:String \$format:[MediaFormat]\$status:MediaStatus \$countryOfOrigin:CountryCode \$source:MediaSource \$season:MediaSeason \$seasonYear:Int \$year:String \$onList:Boolean \$yearLesser:FuzzyDateInt \$yearGreater:FuzzyDateInt \$episodeLesser:Int \$episodeGreater:Int \$durationLesser:Int \$durationGreater:Int \$chapterLesser:Int \$chapterGreater:Int \$volumeLesser:Int \$volumeGreater:Int \$licensedBy:[Int]\$isLicensed:Boolean \$genres:[String]\$excludedGenres:[String]\$tags:[String]\$excludedTags:[String]\$minimumTagRank:Int \$sort:[MediaSort]=[POPULARITY_DESC,SCORE_DESC]){Page(page:\$page,perPage:$n){pageInfo{total perPage currentPage lastPage hasNextPage}media(id:\$id type:\$type season:\$season format_in:\$format status:\$status countryOfOrigin:\$countryOfOrigin source:\$source search:\$search onList:\$onList seasonYear:\$seasonYear startDate_like:\$year startDate_lesser:\$yearLesser startDate_greater:\$yearGreater episodes_lesser:\$episodeLesser episodes_greater:\$episodeGreater duration_lesser:\$durationLesser duration_greater:\$durationGreater chapters_lesser:\$chapterLesser chapters_greater:\$chapterGreater volumes_lesser:\$volumeLesser volumes_greater:\$volumeGreater licensedById_in:\$licensedBy isLicensed:\$isLicensed genre_in:\$genres genre_not_in:\$excludedGenres tag_in:\$tags tag_not_in:\$excludedTags minimumTagRank:\$minimumTagRank sort:\$sort isAdult:\$isAdult){id title{userPreferred}coverImage{extraLarge large color}startDate{year month day}endDate{year month day}bannerImage season seasonYear description type format status(version:2)chapters duration chapters volumes genres isAdult averageScore popularity nextAiringEpisode{airingAt timeUntilAiring episode}mediaListEntry{id status}studios(isMain:true){edges{isMain node{id name}}}}}}",
    "variables": {
      "page": page,
      "type": "MANGA",
      "sort": ["TRENDING_DESC", "POPULARITY_DESC"]
    }
  };
  var url = Uri.parse(anilistEndpoint);
  var response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode(query),
  );
  if (response.statusCode == 500) {
    if (attempt < 5) {
      List<MangaModel> returnList =
          await getMangaModelListTrending(page, n, attempt++);
      return returnList;
    }
    return [];
  } else {
    List<dynamic> media = jsonDecode(response.body)["data"]["Page"]["media"];
    List<MangaModel> list = [];
    for (int i = 0; i < n; i++) {
      Map<String, dynamic> json = media[i];
      list.add(MangaModel(
        id: json["id"],
        title: json["title"]["userPreferred"],
        coverImage: json["coverImage"]["large"],
        bannerImage: json["bannerImage"],
        startDate:
            "${json["startDate"]["day"]}/${json["startDate"]["month"]}/${json["startDate"]["year"]}",
        endDate:
            "${json["endDate"]["day"]}/${json["endDate"]["month"]}/${json["endDate"]["year"]}",
        type: json["type"],
        description: json["description"],
        status: json["status"],
        averageScore: json["averageScore"],
        chapters: json["chapters"],
        duration: json["duration"],
        format: json["format"],
      ));
    }
    // print(list);
    return list;
  }
}

Future<List<MangaModel>> getMangaModelListYearlyPopular(
    int page, int year, int attempt, int n) async {
  Map<String, dynamic> query = {
    "query":
        "query(\$page:Int \$id:Int \$type:MediaType \$isAdult:Boolean = false \$search:String \$format:[MediaFormat]\$status:MediaStatus \$countryOfOrigin:CountryCode \$source:MediaSource \$season:MediaSeason \$seasonYear:Int \$year:String \$onList:Boolean \$yearLesser:FuzzyDateInt \$yearGreater:FuzzyDateInt \$episodeLesser:Int \$episodeGreater:Int \$durationLesser:Int \$durationGreater:Int \$chapterLesser:Int \$chapterGreater:Int \$volumeLesser:Int \$volumeGreater:Int \$licensedBy:[Int]\$isLicensed:Boolean \$genres:[String]\$excludedGenres:[String]\$tags:[String]\$excludedTags:[String]\$minimumTagRank:Int \$sort:[MediaSort]=[POPULARITY_DESC,SCORE_DESC]){Page(page:\$page,perPage:$n){pageInfo{total perPage currentPage lastPage hasNextPage}media(id:\$id type:\$type season:\$season format_in:\$format status:\$status countryOfOrigin:\$countryOfOrigin source:\$source search:\$search onList:\$onList seasonYear:\$seasonYear startDate_like:\$year startDate_lesser:\$yearLesser startDate_greater:\$yearGreater episodes_lesser:\$episodeLesser episodes_greater:\$episodeGreater duration_lesser:\$durationLesser duration_greater:\$durationGreater chapters_lesser:\$chapterLesser chapters_greater:\$chapterGreater volumes_lesser:\$volumeLesser volumes_greater:\$volumeGreater licensedById_in:\$licensedBy isLicensed:\$isLicensed genre_in:\$genres genre_not_in:\$excludedGenres tag_in:\$tags tag_not_in:\$excludedTags minimumTagRank:\$minimumTagRank sort:\$sort isAdult:\$isAdult){id title{userPreferred}coverImage{extraLarge large color}startDate{year month day}endDate{year month day}bannerImage season seasonYear description type format status(version:2)episodes duration chapters volumes genres isAdult averageScore popularity nextAiringEpisode{airingAt timeUntilAiring episode}mediaListEntry{id status}studios(isMain:true){edges{isMain node{id name}}}}}}",
    "variables": {
      "page": page,
      "type": "MANGA",
      "year": "${year.toString()}%",
      /* "season": "SPRING", */
    }
  };

  var url = Uri.parse(anilistEndpoint);
  var response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode(query),
  );
  if (response.statusCode == 500) {
    if(attempt < 5){
      List<MangaModel> returnList = await getMangaModelListRecentlyReleased(page, year, attempt++);
      return returnList;
    }
    return [];
  } else {
    print(response.body);
    List<dynamic> media = jsonDecode(response.body)["data"]["Page"]["media"];
    List<MangaModel> list = [];
    for (int i = 0; i < media.length; i++) {
      Map<String, dynamic> json = media[i];
      list.add(MangaModel(
        id: json["id"],
        title: json["title"]["userPreferred"],
        coverImage: json["coverImage"]["large"],
        bannerImage: json["bannerImage"],
        startDate:
            "${json["startDate"]["day"]}/${json["startDate"]["month"]}/${json["startDate"]["year"]}",
        endDate:
            "${json["endDate"]["day"]}/${json["endDate"]["month"]}/${json["endDate"]["year"]}",
        type: json["type"],
        description: json["description"],
        status: json["status"],
        averageScore: json["averageScore"],
        chapters: json["chapters"],
        duration: json["duration"],
        format: json["format"],
      ));
    }
    return list;
  }
}



//TODO fix for mangas
Future<List<MangaModel>> getMangaModelListRecentlyReleased(
    int page, int n, int attempt) async {
  Map<String, dynamic> query = {
    "query":
        "query{ Page(page: $page, perPage: $n) { airingSchedules (sort: TIME_DESC, notYetAired: false) {episode media { id title { userPreferred } coverImage { large } bannerImage format startDate { year month day } endDate { year month day } type description status averageScore episodes duration}}}}"
  };

  var url = Uri.parse(anilistEndpoint);
  var response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode(query),
  );
  if (response.statusCode == 500) {
    if (attempt < 5) {
      List<MangaModel> returnList =
          await getMangaModelListRecentlyReleased(page, n, attempt++);
      return returnList;
    }
    return [];
  } else {
    List<dynamic> media =
        jsonDecode(response.body)["data"]["Page"]["airingSchedules"];
    List<MangaModel> list = [];
    for (int i = 0; i < media.length; i++) {
      var currentMedia = media[i]["media"];
      list.add(MangaModel(
        id: currentMedia["id"],
        title: currentMedia["title"]["userPreferred"],
        coverImage: currentMedia["coverImage"]["large"],
        bannerImage: currentMedia["bannerImage"],
        startDate:
            "${currentMedia["startDate"]["day"]}/${currentMedia["startDate"]["month"]}/${currentMedia["startDate"]["year"]}",
        endDate:
            "${currentMedia["endDate"]["day"]}/${currentMedia["endDate"]["month"]}/${currentMedia["endDate"]["year"]}",
        type: currentMedia["type"],
        status: currentMedia["status"],
        averageScore: currentMedia["averageScore"],
        chapters: currentMedia["chapters"],
        currentEpisode: media[i]["episode"],
        duration: currentMedia["duration"],
        description: currentMedia["description"],
        format: currentMedia["format"],
      ));
    }
    for (int i = 0; i < list.length; i++) {
      for (int j = i + 1; j < list.length - 1; j++) {
        if (list[i].id == list[j].id) {
          list.removeAt(j);
        }
      }
    }
    return list;
  }
}
//TODO fix
Future<int> getMangaCurrentChapter(int mediaId) async{
  var url = Uri.parse(anilistEndpoint);
  Map<String, dynamic> query = {
    "query": "query{ AiringSchedule(mediaId: $mediaId, sort: TIME_DESC, notYetAired: false){ episode } }",
  };
  var response = await http.post(
    url,
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    },
    body: json.encode(query),
  );
  Map<String, dynamic> jsonResponse = json.decode(response.body);
  return jsonResponse["data"]["AiringSchedule"]["episode"];
}
//TODO fix for manga
Future<UserMediaModel> getUserMangaInfo(int mediaId, int attempt) async {
  var url = Uri.parse(anilistEndpoint);
  Map<String, dynamic> query = {
    "query": "query{ Media(id: $mediaId){ mediaListEntry { score progress repeat priority status startedAt{day month year} completedAt{day month year} } } }",
  };
  var response = await http.post(
    url,
    headers: {
      "Authorization": "Bearer $accessToken",
      "Content-Type": "application/json",
    },
    body: json.encode(query),
  );
  if (response.statusCode == 500){
    if(attempt < 5){
      return getUserAnimeInfo(mediaId, attempt++);
    }
  }
  Map<String, dynamic> jsonResponse = json.decode(response.body);
  if (jsonResponse["data"]["Media"]["mediaListEntry"] == null){
    return UserMediaModel(
      score: 0,
      progress: 0,
      repeat: 0,
      priority: 0,
      status: "",
      startDate: "~/~/~",
      endDate: "~/~/~",
    );
  }
  Map<String, dynamic> mediaListEntry =
      jsonResponse["data"]["Media"]["mediaListEntry"];
  return UserMediaModel(
    score: mediaListEntry["score"],
    progress: mediaListEntry["progress"],
    repeat: mediaListEntry["repeat"],
    priority: mediaListEntry["priority"],
    status: mediaListEntry["status"],
    startDate: "${mediaListEntry["startedAt"]["day"]}/${mediaListEntry["startedAt"]["month"]}/${mediaListEntry["startedAt"]["year"]}",
    endDate: "${mediaListEntry["completedAt"]["day"]}/${mediaListEntry["completedAt"]["month"]}/${mediaListEntry["completedAt"]["year"]}",
  );
}

void deleteUserManga(int mediaId) async{
  var url = Uri.parse(anilistEndpoint);

  Map<String, dynamic> query1 = {
    "query": "query(\$mediaId:Int){ MediaList(mediaId:\$mediaId){ id } }",
    "variables" : {
      "mediaId" : mediaId,
    },
  };
  var response1 = await http.post(
    url,
    headers: {
      "Authorization": "Bearer $accessToken",
      "Content-Type": "application/json",
    },
    body: json.encode(query1),
  );

  int entryId = jsonDecode(response1.body)["data"]["MediaList"]["id"];

  Map<String, dynamic> query = {
    "query": "mutation (\$entryId: Int) {DeleteMediaListEntry(id: \$entryId){ deleted }}",
    "variables" : {
      "entryId" : entryId,
    },
  };
  var response = await http.post(
    url,
    headers: {
      "Authorization": "Bearer $accessToken",
      "Content-Type": "application/json",
    },
    body: json.encode(query),
  );
  print(response.body);
}


