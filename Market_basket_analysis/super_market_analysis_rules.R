df=read.transactions('supper_market_class_data.csv',sep=',')
head(df)
library(arulesViz)
library(arules)
itemFrequencyPlot(df, topN=10, type="absolute", main="Item Frequency")
crossTable(df,measure='support',sort=T)[1:5,1:5]
crossTable(df,measure='lift',sort=T)[1:5,1:5]
crossTable(df,measure='chiSquared',sort=T)[1:5,1:5]
rule<-apriori(df,
              parameter = list(support=0.03,
                               minlen=2,
                               maxlen=4,
                               target='rules'))
inspect(sort(rule,by='lift',decreasing = T)[1:3])
plot(rule,method = 'grouped')

subrule<-head(rule,n=10,by='lift')
plot(subrule,method = 'grouped')
plot(subrule,method='graph')
itemset<-apriori(df,parameter = list(support=.03,# you only want to get the ones with 0.001 support
                                     minlen=2,
                                     maxlen=4,
                                     target='frequent'))
summary(itemset)

inspect(sort(itemset, by= 'support', decreasing = T)[1:5])
