

############################################################
############        Data Preprocessing          ############
############################################################


### 1. 데이터 읽기

#install.packages("readr")
library(readr)

# read_csv 함수를 이용하여 데이터 읽음.
df_train <- read_csv("data/train_users_2.csv")  # -> col_types 속성에 "ccincc..." 이런식으로 표기해서 불러올 데이터타입 설정 가능.

# 데이터의 구조 확인.
str(df_train)






### 2. 데이터 전처리 및 시각화

# dplyr를 이용해 데이터 필터링.
# dplyr 사용법 참고 링크 : http://wsyang.com/2014/02/introduction-to-dplyr/
library(dplyr)

# df_train을 러프하게 필터링. (일단 한번 돌려보는 것이 목적이기 때문.)
# 필터링 기준 : gender가 -unknown-이나 OTHER가 아닌것, age가 NA가 아닌것, first_affiliate_tracked가 NA가 아닌것, first_browser가 -unknown-이 아닌것을 필터링. 
df_train_filtered <- df_train %>% filter(gender != "-unknown-" & gender != "OTHER" & !is.na(age) & !is.na(first_affiliate_tracked) & first_browser != "-unknown-")


# 필터링된 데이터가 총 몇개인지 확인.
nrow(df_train_filtered)
# -> 약 10만개의 데이터로 줄어듬.

# 전체 데이터와 비교해서 얼마나 줄어들었나 확인.
nrow(df_train_filtered)/nrow(df_train)
# -> 전체의 약 절반이 됨..
# 그래도 '일단' 필터링된 데이터로 실습하고, 추후에 보완.

## 필터링된 요소 중 어떤 것이 많은 비율을 차지하는지 탐색.
# 나머지는 고만고만 한데, gender와 age가 문제..

# 먼저 gender 데이터 봄.
barplot(table(df_train$gender)) 
# -> gender -unknown-이 상당히 많음..!
# OTHER는 그냥 무시해도 될 수준.

# age 데이터는 어떨지..?
table_age <- table(df_train$age, exclude = NULL) 
table_age 
# -> 전체의 거의 절반 가량(87990)이 NA데이터..
barplot(table_age) 
# -> 시각화하면 많다는 것을 확인.


## gender -unknown-인 사람이 age도 NA이지 않을까?
# 먼저, gender -unknown-이고, age도 NA인 사람 수는? (교집합)
nrow(df_train   %>%  filter(is.na(age) & gender == "-unknown-")) 
# -> 78845
# gender -unknown-이거나, age NA인 사람 수는? (합집합)
nrow(df_train   %>%  filter(is.na(age) | gender == "-unknown-")) 
# -> 104833
## -> 두 속성의 교집합 비율이 굉장히 높음. (추후 인터폴레이션 할 때 이 탐색결과 활용.)







### 3. (어쨋든..) 데이터 저장.
write_csv(df_train_filtered, "data/train_users_filtered.csv")








