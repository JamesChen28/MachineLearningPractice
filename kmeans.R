### k-means
### https://ithelp.ithome.com.tw/articles/10187906

kmiris <- iris[-5] #�h����5�Ӹ�Ʀ�    
##��3�s�Anstart=10 defaut����10��  ���ĸ�ư� 
km <- kmeans(kmiris, centers = 3, nstart = 10)

#�]���s����e���G 
plot(formula = Petal.Length ~ Petal.Width, data = kmiris, col = km$cluster, main = "�N����ᰵ���s", xlab = "��ä�e��", ylab = "��ä����")

ggplot(kmiris, aes(x = Petal.Length, y = Petal.Width)) +
	geom_point(aes(color = factor(km$cluster))) +
	stat_density2d(aes(color = factor(km$cluster)))


### �դ��Z������MWSS(Within Cluster Sum of Squares) �V�p�V�n
### �ն��Z������MBSS(Between Cluster Sum of Squares) �V�j�V�n
### �`�����t����MTSS(Total Cluster Sum of Squares)

(WSS <- km$tot.withinss)
(BSS <- km$betweenss)
(TSS <- BSS + WSS)
(ratio <- WSS / TSS)


klist <- seq(1:10)
knnFunction <- function(x) {
    kms <- kmeans(kmiris, centers = x, nstart = 1)
    ratio <- kms$tot.withinss / (kms$tot.withinss + kms$betweenss)
}
ratios <- sapply(klist, knnFunction)

# k value�P�ǽT�׵�ı��
df <- data.frame(kv = klist, KMratio = ratios)

ggplot(df, aes(x = kv, y = KMratio, label = kv, color = KMratio)) +
geom_point(size = 5) + geom_text(vjust = 2)



