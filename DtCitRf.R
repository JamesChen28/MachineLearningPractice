### Decision tree
### Conditional Inference Tree
### Random forest
### https://ithelp.ithome.com.tw/articles/10187561

install.packages("party")
install.packages("AER")
install.packages("rpart")
install.packages("rpart.plot")
install.packages("rattle")
install.packages("randomForest") 

library(party)
library(AER)
library(rpart)
library(rpart.plot)
library(rattle)
library(randomForest) 


### Decision tree
library("rpart")
library("rpart.plot")
library("rattle")

# 1. ���Jcreditcard��ƶ�(�]�t1,319���[����աA�@��12���ܼ�)
data(CreditCard)
dim(CreditCard)
colnames(CreditCard)

#���]�ڭ̥u�n�H�U���(card:�O�_�֭�d���B�H�ζS�z���i�ơB�~�֡B���J(����)�B�ۦ����v���p�B���Ӧ~��)
bankcard <- subset(CreditCard, select = c(card, reports, age, income, owner, months))
#�N�O�_�֭�d���ഫ��0/1�ƭ�
bankcard$card <- ifelse(bankcard$card == "yes", 1, 0)


# 2. ���ռҫ�
#���o�`����
n <- nrow(bankcard)
#�]�w�H���ƺؤl
set.seed(1117)
#�N�ƾڶ��ǭ��s�ƦC
newbankcard <- bankcard[sample(n), ]

#���X�˥��ƪ�idx
t_idx <- sample(seq_len(n), size = round(0.7 * n))

#�V�m��ƻP���ո�Ƥ��: 70%�ؼҡA30%����
traindata <- newbankcard[t_idx, ]
testdata <- newbankcard[-t_idx, ]


# 3. �إߨM����ҫ� 
dtreeM <- rpart(formula = card ~ ., data = traindata, method = "class", control = rpart.control(cp = 0.001))


# 4. ��rattle�e�X�F�`���M����(Rx: rxDTree)
fancyRpartPlot(dtreeM)


# 5. �w��
result_dt <- predict(dtreeM, newdata = testdata, type = "class")


# 6. �إ߲V�c�x�}(confusion matrix)�[��ҫ����{
cm_dt <- table(testdata$card, result_dt, dnn = c("���", "�w��"))
cm_dt

# 7. ���T�v
#�p��ַǥd���T�v
cm_dt[4]/sum(cm_dt[, 2])

#�p��ڸɥ󥿽T�v
cm_dt[1]/sum(cm_dt[, 1])

#����ǽT�v(���X�﨤/�`��)
accuracy_dt <- sum(diag(cm_dt))/sum(cm_dt)
accuracy_dt



### Conditional Inference Tree
library(party)

ct <- ctree(Species ~ ., data = iris)
plot(ct, main = "������׾�")
table(iris$Species, predict(ct))



### Random forest
library(randomForest)

# 1.
set.seed(1117)


# 2. �]�H����˪L�ҫ�
randomforestM <- randomForest(card ~ ., data = traindata, importane = T, proximity = T, do.trace = 100)
randomforestM


#���~�v: �Q��OOB(Out Of Bag)�B��X�Ӫ�
plot(randomforestM)

#�Ŷq�C�@���ܼƹ�Y�Ȫ����n�ʡA����p���I�ĤG��
randomForest::importance(randomforestM)
	# round(importance(randomforestM), 2)

# 3. �w��
result_rf <- predict(randomforestM, newdata = testdata)
result_rf_Approved <- ifelse(result_rf > 0.6, 1, 0)


# 4. �إ߲V�c�x�}(confusion matrix)�[��ҫ����{
cm_rf <- table(testdata$card, result_rf_Approved, dnn = c("���", "�w��"))
cm_rf


# 5. ���T�v
#�p��ַǥd���T�v
cm_rf[4] / sum(cm_rf[, 2])

#�p��ڸɥ󥿽T�v
cm_rf[1] / sum(cm_rf[, 1])

#����ǽT�v(���X�﨤/�`��)
accuracy_rf <- sum(diag(cm_rf)) / sum(cm_rf)
accuracy_rf





