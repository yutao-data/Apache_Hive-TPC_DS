
library(ggplot2)
library(tidyverse)
library(dplyr)

path = "//Users//zzy13//Desktop//Classes_at_ULB//Data_Warehouse_Systems_419//TPC-DS//time tables"
setwd(path)
result_01gb = read.csv("//Users//zzy13//Desktop//Classes_at_ULB//Data_Warehouse_Systems_419//TPC-DS//results//tests//power//results_01gb_1times//query_execution_time.csv", header = TRUE)
######### power_plot function: 1 time query in specific scale ############################
power_plot = function(data=power_6times, x_col="query", y_col, number, count =1){
  avg_power = colSums(data)[-1]/99
  plot = ggplot(data, aes_string(x = x_col, y = y_col)) +
    geom_bar(stat = "identity", fill = "#004d80", width =0.7) +
    geom_hline(aes(yintercept=avg_power[count]), linewidth = 1, color = "#B1637B") + # "#4C7EB5"
    labs(x = "Query", y = "Exectuion Time (Seconds)") +
    scale_x_continuous(breaks = seq(1, 99, by = 1),expand = c(0, 1)) + 
    scale_y_continuous(expand = c(0, 0)) +
    theme_classic() +
    coord_flip()
  inse = number[count]
  save_name = paste("plot_",inse,".pdf",sep = "")
  ggsave(save_name, plot, width = 9, height = 12, dpi = 1000)
}
for (i in 1:length(num)) {
  power_plot(y_col = y_num[i],number = num, count = i)
}
###### For 6 times results: ##############################
num_6 = c("01", "03", "05", "1")
power_6times = data.frame(
  # format of power_6times: col1: query, col...: result
  query = 1:99,
  result_01gb = NA,
  result_03gb = NA ,
  result_05gb = NA,
  result_1gb = NA)
for (i in c(4) ) { # 重跑-- 1:length(num_6) 
  name_6t = paste("//Users//zzy13//Desktop//Classes_at_ULB//Data_Warehouse_Systems_419//TPC-DS//results//tests//power//power_", num_6[i],"gb_6times.csv",sep = "")
  power_6t = read.csv(name_6t, header = TRUE)
  colnames(power_6t) = c("query", "time")
  power_6t_avg <- power_6t %>%
    group_by(query) %>%  # group by query
    summarize(mean_time = mean(time))  # calculate avg time
  power_6times[,(i+1)] = power_6t_avg$mean_time
}
num_6t = as.character(paste("final",num_6,"_06",sep = ""))
for (i in c(4) ) { # 重跑-- 1:length(num_6t)
  power_plot(data = power_6times, x_col = "query", y_col = paste("result_", num_6[i],"gb", sep = ""), number = num_6t, count = i)
}

######### 4 scale running time in one plot ##########################
power_result_long = power_6times %>%
  gather(key = "label", value = "value", -query) %>% 
  mutate(label = factor(label, levels = c("result_01gb", "result_03gb", "result_05gb", "result_1gb"),
                        labels = c("Scale 0.1GB", "Scale 0.3GB", "Scale 0.5GB", "Scale 1GB"), ordered = TRUE))

power_result_long <- power_6times %>%
  pivot_longer(cols = starts_with("result"), names_to = "label", values_to = "value") %>% 
  mutate(Label = factor(Label, levels = c("result_01gb", "result_03gb", "result_05gb", "result_1gb"),
                        labels = c("Scale 0.1GB", "Scale 0.3GB", "Scale 0.5GB", "Scale 1GB"), ordered = TRUE))

## 4 scale in tot plot
plot_tot4 = ggplot(power_result_long, aes(x = query, y = value, color = label)) +
  geom_line(aes(group = label), size = 1) +
  geom_point(size = 2) +
  labs(x = "Query", y = "Execution Time (Seconds)") +
  scale_x_continuous(breaks = seq(1, 99, by = 1), expand = c(0, 1),limits = c(1,100)) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, max(power_result_long$value)+10)) +
  theme_classic() +
  theme(legend.position = "bottom") +  # 将图例放在顶部
  coord_flip()+
  scale_color_manual(values = c("Scale 0.1GB"= "#004d80", "Scale 0.3GB" = "#B1637B", "Scale 0.5GB" = "#009DA9", "Scale 1GB" = "#7065A8"))

ggsave("plot_final_tot4.pdf", plot_tot4, width = 9, height = 12, dpi = 1000)

# 重跑--
## eliminate 81
power_result_long_eli = power_6times %>%
  filter(!query %in% c(81)) %>% 
  gather(key = "label", value = "value", -query) %>% 
  mutate(label = factor(label, levels = c("result_01gb", "result_03gb", "result_05gb", "result_1gb"),
                        labels = c("Scale 0.1GB", "Scale 0.3GB", "Scale 0.5GB", "Scale 1GB"), ordered = TRUE))

## 4 scale in tot plot
plot_tot4_eil = ggplot(power_result_long_eli, aes(x = query, y = value, color = label)) +
  geom_line(aes(group = label), size = 1) +
  geom_point(size = 2) +
  labs(x = "Query", y = "Execution Time (Seconds)") +
  scale_x_continuous(breaks = seq(1, 100, by = 1), expand = c(0,1),limits = c(1,100)) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, max(power_result_long_eli$value)+10)) +
  theme_classic() +
  theme(legend.position = "bottom") +  # 将图例放在顶部
  coord_flip()+
  scale_color_manual(values = c("Scale 0.1GB"= "#004d80", "Scale 0.3GB" = "#B1637B", "Scale 0.5GB" = "#009DA9", "Scale 1GB" = "#7065A8"))
ggsave("plot_final-eli81.pdf", plot_tot4_eil, width = 9, height = 12, dpi = 1000)

####### throughput results #########################
through_name = "//Users//zzy13//Desktop//Classes_at_ULB//Data_Warehouse_Systems_419//TPC-DS//results//tests//throughput//throughput_01gb_4s.csv"
throughput = read.csv(through_name, header = TRUE) 
colnames(throughput) = c("query", "time", "user")
######## throughput group by queries #######################
tp_by_query = throughput %>% 
  group_by(query) %>% 
  summarise(mean_time = mean(time))
tp_num = as.character(c("tp_by_q"))
for (i in 1:length(tp_num)) {
  power_plot(data = tp_by_query, y_col = "mean_time", number = tp_num, count = i)
}

######### throughput v.s. power ##########################
tp_by_query_copy = tp_by_query
colnames(tp_by_query_copy) = c("query", "result_01gb")
power_01_multi2 = power_6times %>%
  mutate(result_01gb = result_01gb * 2) %>% 
  select(query, result_01gb)
power_01_multi4 = power_6times %>% 
  mutate(result_01gb = result_01gb * 4) %>% 
  select(query, result_01gb)

th_with_pow =  bind_rows(
  tp_by_query_copy %>% select(query, result_01gb) %>% mutate(label = factor("Throughput Test")),
  power_6times %>% select(query, result_01gb) %>% mutate(label = factor("Power Test")),
  power_01_multi2 %>% mutate(label = factor("2*Power Test")),
  power_01_multi4 %>% mutate(label = factor("4*Power Test"))
) 
colnames(th_with_pow) = c("query", "Value","Label")
th_with_pow_eli22 = th_with_pow %>% filter(query != 22)

## th_with_pow plot
plot_tp_pow = ggplot(th_with_pow, aes(x = query, y = Value, color = Label)) +
  geom_point(size = 2) +
  geom_line(aes(group = Label), size = 1) +
  labs(x = "Query", y = "Execution Time (Seconds)") +
  scale_x_continuous(breaks = seq(1, 100, by = 1), expand = c(0, 1),limits = c(1,100)) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, max(th_with_pow$Value)+10)) +
  theme_classic() +
  theme(legend.position = "bottom") +
  coord_flip()+
  scale_color_manual(values = c("Power Test"= "#004d80", "Throughput Test" = "#B1637B", "2*Power Test" = "#009DA9", "4*Power Test" = "#7065A8"))+
  scale_linetype_manual(values = c("Power Test" = "solid", "Throughput Test" = "solid", "2*Power Test" = 'dashed', "4*Power Test" = "dashed") )
ggsave("plot_final_tp_pow_compare.pdf", plot_tp_pow, width = 9, height = 12, dpi = 1000)
# "Scale 0.5GB" = "#009DA9", "Scale 1GB" = "#7065A8"

######## throughput tot group by users #######################
tp_by_user = throughput %>% 
  group_by(user) %>% 
  summarise(mean_time = mean(time))
tp_by_user_plot = ggplot(tp_by_user, aes(x = user, y = mean_time)) +
  geom_bar(stat = "identity", fill = "#004d80", width =0.7) +
  labs(x = "Users", y = "Average Execution Time Per Query (Seconds)") +
  #scale_x_continuous(breaks = seq(1, 99, by = 1),expand = c(0, 1)) + 
  scale_y_continuous(breaks = seq(0, 28, by = 2), expand = c(0, 0), limits = c(0,30)) +
  theme_classic()
ggsave("plot_tp_by_user.pdf", tp_by_user_plot, width = 8, height = 6, dpi = 1000)
###### load time ######################
load_time = read.csv("//Users//zzy13//Desktop//Classes_at_ULB//Data_Warehouse_Systems_419//TPC-DS//time tables//load_time.csv", header = TRUE)
load_time$Scale <- as.character(load_time$Scale)
load_plot_1 = ggplot(load_time, aes(x = Scale, y = Load.Time)) +
  #geom_bar(stat = "identity", fill = "#004d80") +
  geom_point(colour = "#004d80", size = 3)+
  geom_line(colour = "#004d80",aes(group = 1)) +
  labs(x = "Scale Factor", y = "Load Time (Seconds)") +
  scale_y_continuous(breaks = c(0:8), expand = c(0, 1)) +
  scale_x_discrete(breaks = load_time$Scale)+
  #scale_x_continuous(breaks = seq(0, 8, by = 2)) + 
  #,expand = c(0, 1)
  theme_classic() 
load_plot_1
ggsave("load_time_1.pdf", load_plot_1, width = 8, height = 6, dpi = 1000)

###### power test total time ######################
load_time $ power_tot = colSums(power_6times)[-1]
power_tot = ggplot(load_time, aes(x = Scale, y = power_tot)) +
  geom_point(colour = "#004d80", size = 3)+
  geom_line(colour = "#004d80",aes(group = 1)) +
  labs(x = "Scale Factor", y = "Execution Time in Total (Seconds)") +
  scale_y_continuous(breaks = seq(0,1900,by=50)) +
  scale_x_discrete(breaks = load_time$Scale)+
  #scale_x_continuous(breaks = seq(0, 8, by = 2)) + 
  #,expand = c(0, 1)
  theme_classic() 
power_tot
ggsave("power_final_tot.pdf", power_tot, width = 8, height = 6, dpi = 1000)

###### power test time  specific queries ######################
set_seed = 150 # seed = 100, 2000, 150, 50
condition = power_6times$result_01gb < power_6times$result_03gb & power_6times$result_03gb< power_6times$result_05gb & power_6times$result_05gb < power_6times$result_1gb
satify_power_all = power_6times[condition,]
seed = set_seed
satify_power = satify_power_all[sample(1:length(satify_power_all[,1]),4),]
satify_2 = as.data.frame(t(satify_power)[-1,])
satify_2$scale = as.character(c(0.1, 0.3,0.5,1))
stf_colname = colnames(satify_2)[-5]
colnames(satify_2) = c(paste("q",stf_colname,sep = ""),"scale")
stf_colname_2 = colnames(satify_2)[-5]
# colname_1: query只有数字
# colname_2: q+数字
satisfy_plot = function(data=satify_2, x_col="scale", y_col, colname_1, colname_2, count =1){
  title = paste("Query ",colname_1[count], sep="")
  plot = ggplot(data, aes_string(x = x_col, y = y_col)) +
    geom_bar(stat = "identity", fill = "#004d80", width =0.7) +
    labs(x = "Scale Factors", y = "Exectuion Time (Seconds)") +
    scale_y_continuous(breaks = seq(1, 20, by = 2), expand = c(0, 0), limits = c(0,16)) +
    ggtitle(title)+
    theme_classic()  +
    theme(plot.title = element_text(hjust = 0.5, vjust = 0.5)) 
    #coord_flip()
  save_name = paste("plot_final_stfy_",colname_1[count],".pdf",sep = "")
  ggsave(save_name, plot, width = 8, height = 6, dpi = 1000)
}
for (i in 1:length(stf_colname_2)) {
  satisfy_plot(data = satify_2, y_col = stf_colname_2[i],colname_1 = stf_colname, colname_2 = stf_colname_2, count = i)
}
# Unsatisfy: results that do not satisfy 0.1<0.3<0.5<1 #####################
unsatisfy = power_6times[!(power_6times$query %in% satify_power_all$query), ]
seed = set_seed 
unstf_power = unsatisfy[sample(1:length(unsatisfy[,1]),4),]
unsatify_power_t = as.data.frame(t(unstf_power)[-1,])
unsatify_power_t$scale = as.character(c(0.1, 0.3,0.5,1))
unstf_colname = colnames(unsatify_power_t)[-5]
colnames(unsatify_power_t) = c(paste("q",unstf_colname,sep = ""),"scale")
unstf_colname_2 = colnames(unsatify_power_t)[-5]
unsatisfy_plot = function(data=unsatify_power_t, x_col="scale", y_col, colname_1, colname_2, count =1){
  title = paste("Query ",colname_1[count], sep="")
  ymax = ceiling(max(unsatify_power_t[,1:4]))
  plot = ggplot(data, aes_string(x = x_col, y = y_col)) +
    geom_bar(stat = "identity", fill = "#004d80", width =0.7) +
    labs(x = "Scale Factors", y = "Exectuion Time (Seconds)") +
    scale_y_continuous(breaks = seq(1, ymax, by = 2), expand = c(0, 0), limits = c(0, ymax) ) +
    ggtitle(title)+
    theme_classic()  +
    theme(plot.title = element_text(hjust = 0.5, vjust = 0.5)) 
  save_name = paste("plot_unstfy_",colname_1[count],".pdf",sep = "")
  ggsave(save_name, plot, width = 8, height = 6, dpi = 1000)
}
for (i in 1:length(unstf_colname_2)) {
  unsatisfy_plot(data = unsatify_power_t, y_col = unstf_colname_2[i], colname_1 = unstf_colname, colname_2 = unstf_colname_2, count = i)
}



