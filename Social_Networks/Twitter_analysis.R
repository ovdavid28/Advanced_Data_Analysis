install.packages(c('twitteR','igraph','dplyr'))
library(twitteR)
library(igraph)
library(dplyr)
api_key<-''
api_secret<-''
access_token<-'-'
access_token_secret<-''
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)
alltweets<-searchTwitter('climatechange', n = 500)
alltweets<-twListToDF(alltweets)
tweets<-alltweets[1:500,]
tweets


split_point = split(tweets, tweets$isRetweet)

reTweets = mutate(split_point[['TRUE']], sender = substr(text, 5, regexpr(':', text) - 1))
edge_list = as.data.frame(cbind(sender = tolower(reTweets$sender), receiver = tolower(reTweets$screenName)))

edge_list = count(edge_list, sender, receiver)

edge_list[1:5,]


reTweets_graph <- graph_from_data_frame(d=edge_list, directed=T)

save(reTweets_graph, file = "retweet-graph.Rdata")

par(bg="white", mar=c(1,1,1,1))

plot(reTweets_graph, layout=layout.fruchterman.reingold,
     
     vertex.color="blue",
     
     vertex.size=(degree(reTweets_graph, mode = "in")), #sized by in-degree centrality
     
     vertex.label = NA,
     
     edge.arrow.size=0.8,
     
     edge.arrow.width=0.5,
     
     edge.width=edge_attr(reTweets_graph)$n/10, #sized by edge weight
     
     edge.color=hsv(h=.95, s=1, v=.7, alpha=0.5))

title("Retweet Climate Change Network", cex.main=1, col.main="black")
