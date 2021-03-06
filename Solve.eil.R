
options(digits = 4)

x <- read.csv("x51.txt",header = FALSE,sep = "\t")
x <- as.matrix(x[,-1]) ; colnames(x) <- c("x_coord")

y <- read.csv("y51.txt",header = FALSE,sep = "\t")
y <- as.matrix(y[,-1]) ; colnames(y) <- c("y_coord")

demand <- read.csv("dem51.txt",header = FALSE,sep = "\t")
demand <- as.matrix(demand[,-1]) ; colnames(demand) <- c("demand")

eil51 <- as.matrix(cbind(x,y,demand))



x <- read.csv("x76.txt",header = FALSE,sep = "\t")
x <- as.matrix(x[,-1]) ; colnames(x) <- c("x_coord")

y <- read.csv("y76.txt",header = FALSE,sep = "\t")
y <- as.matrix(y[,-1]) ; colnames(y) <- c("y_coord")

demand <- read.csv("dem76.txt",header = FALSE,sep = "\t")
demand <- as.matrix(demand[,-1]) ; colnames(demand) <- c("demand")

eil76 <- as.matrix(cbind(x,y,demand))


data <- eil51
p <- 3 

distmatrix <- matrix(NA,nrow(data),nrow(data))
for (i in 1:nrow(data)) {
  for (j in 1:nrow(data)) {
    distmatrix[i,j] <- as.double(sqrt((data[i,1] - data[j,1])^2 + (data[i,2] - data[j,2])^2)) 
  }
} 


initial_temp <- 80
final_temp <- 0.01
alpha <- 0.9
L <- 250
current_temp <- initial_temp


Obj.n <- 0
randomPoints <- sort(sample(nrow(data), p))

for (i in 1:nrow(data)){
  distlist <- c()
  for (j in randomPoints){
    distlist <- append(distlist,distmatrix[i,j])
  }
  Obj.n <- Obj.n + as.double(min(distlist)*data[i,"demand"])
}

Obj.Point <- randomPoints
Obj.Point
Objective <- Obj.n
Objective

changeSum <- 0

start_time <- Sys.time()
while(current_temp > final_temp){
  for (n in 0:L){
    randomPoints <- sort(sample(nrow(data),p))
    index <- sample(p,1)
    randomPoints[index] <- sample(nrow(data),1)
    randomPoints
    Obj.n <- 0
    
    for (i in 1:nrow(data)){
      distlist <- c()
      for (j in randomPoints){
        distlist <- append(distlist,distmatrix[i,j])
      }
      Obj.n <- as.double(min(distlist)*data[i,"demand"]) + Obj.n
    }
    
    Delta <- Obj.n - Objective
    if(Delta <= 0){
      Obj.Point <- randomPoints
      Objective <- Obj.n
      changeSum <- 0
    }
    else {
      x <- runif(1)
      if(x <= exp(-Delta/current_temp)){
        Obj.Point <- randomPoints
        Objective <- Obj.n
        changeSum <- 0
      }
      else{
        print(Objective)
        changeSum <- changeSum + 1
      }
    }
    if(changeSum == L*45){
      break
      }
  }
  current_temp <- current_temp * alpha
  if(changeSum == L*45){
    print(paste("Objective function value is not changed for ",changeSum," times"))   
    break
  }
}

Obj.Point
Objective
finish_time <- Sys.time()

CpuTime <- finish_time - start_time
CpuTime




















