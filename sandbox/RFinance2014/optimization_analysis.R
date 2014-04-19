library(PortfolioAnalytics)
library(methods)

# Set the directory where the optimization results are saved
results.dir <- "optimization_results"
figures.dir <- "optimization_figures"


##### Example 1 #####
load(paste(results.dir, "opt.minVarSample.rda", sep="/"))
load(paste(results.dir, "opt.minVarLW.rda", sep="/"))

# Chart the weights through time
png(paste(figures.dir, "weights_minVarSample.png", sep="/"))
chart.Weights(opt.minVarSample, main="minVarSample Weights", legend.loc=NULL)
dev.off()

png(paste(figures.dir, "weights_minVarLW.png", sep="/"))
chart.Weights(opt.minVarLW, main="minVarLW Weights", legend.loc=NULL)
dev.off()

# Compute the returns and chart the performance summary
ret.minVarSample <- summary(opt.minVarSample)$portfolio_returns
ret.minVarRobust <- summary(opt.minVarLW)$portfolio_returns
ret.minVar <- cbind(ret.minVarSample, ret.minVarRobust)
colnames(ret.minVar) <- c("Sample", "LW")

png(paste(figures.dir, "ret_minVar.png", sep="/"))
charts.PerformanceSummary(ret.minVar)
dev.off()

##### Example 2 #####
load(paste(results.dir, "opt.dn.rda", sep="/"))

png(paste(figures.dir, "opt_dn.png", sep="/"))
plot(opt.dn, main="Dollar Neutral Portfolio", risk.col="StdDev", neighbors=10)
dev.off()


# chart.RiskReward(opt, risk.col="StdDev", neighbors=25)
# chart.Weights(opt, plot.type="bar", legend.loc=NULL)
# wts <- extractWeights(opt)
# t(wts) %*% betas
# sum(abs(wts))
# sum(wts[wts > 0])
# sum(wts[wts < 0])
# sum(wts != 0)

##### Example 3 #####
load(file=paste(results.dir, "opt.minES.rda", sep="/"))
load(file=paste(results.dir, "bt.opt.minES.rda", sep="/"))

# ES(R, portfolio_method="component", weights=extractWeights(opt.minES[[1]]))
# extractObjectiveMeasures(opt.minES)

# extract objective measures, out, and weights 
xtract <- extractStats(opt.minES)

# get the 'mean' and 'ES' columns from each element of the list
xtract.mean <- unlist(lapply(xtract, function(x) x[,"mean"]))
xtract.ES <- unlist(lapply(xtract, function(x) x[,"ES"]))


png(paste(figures.dir, "opt_minES.png", sep="/"))
# plot the feasible space
par(mar=c(7,4,4,1)+0.1)
plot(xtract.ES, xtract.mean, col="gray", 
     xlab="ES", ylab="Mean",
     ylim=c(0.005, 0.008),
     xlim=c(0.015, 0.085))

# min ES
points(x=opt.minES[[1]]$objective_measures$ES$MES,
       y=opt.minES[[1]]$objective_measures$mean,
       pch=15, col="purple")
text(x=opt.minES[[1]]$objective_measures$ES$MES,
     y=opt.minES[[1]]$objective_measures$mean,
     labels="Min ES", pos=1, col="purple", cex=0.8)

# min ES with risk budget upper limit on component contribution to risk
points(x=opt.minES[[2]]$objective_measures$ES$MES,
       y=opt.minES[[2]]$objective_measures$mean,
       pch=15, col="black")
text(x=opt.minES[[2]]$objective_measures$ES$MES,
     y=opt.minES[[2]]$objective_measures$mean,
     labels="Min ES RB", pos=4, col="black", cex=0.8)

# min ES with equal (i.e. min concentration) component contribution to risk
points(x=opt.minES[[3]]$objective_measures$ES$MES,
       y=opt.minES[[3]]$objective_measures$mean,
       pch=15, col="darkgreen")
text(x=opt.minES[[3]]$objective_measures$ES$MES,
     y=opt.minES[[3]]$objective_measures$mean,
     labels="Min ES EqRB", pos=4, col="darkgreen", cex=0.8)
# par(mar=c(7,4,4,1)+0.1)
dev.off()

# Chart the risk contribution
#chart.RiskBudget(opt.minES[[1]], risk.type="percentage", neighbors=10)
png(paste(figures.dir, "rb_minES.png", sep="/"))
chart.RiskBudget(opt.minES[[2]], main="Risk Budget Limit", 
                 risk.type="percentage", neighbors=10)
dev.off()

png(paste(figures.dir, "eqrb_minES.png", sep="/"))
chart.RiskBudget(opt.minES[[3]], main="Equal ES Component Contribution", 
                 risk.type="percentage", neighbors=10)
dev.off()

# Plot the risk contribution  of portfolio 1 through time
png(paste(figures.dir, "risk_minES.png", sep="/"))
chart.RiskBudget(bt.opt.minES[[1]], main="Min ES Risk Contribution", 
                 risk.type="percentage")
dev.off()
# Plot the risk contribution  of portfolio 1 through time
png(paste(figures.dir, "weights_minES.png", sep="/"))
chart.Weights(bt.opt.minES[[1]], main="Min ES Weights")
dev.off()

# Plot the risk contribution  of portfolio 3 through time
png(paste(figures.dir, "risk_minESRB.png", sep="/"))
chart.RiskBudget(bt.opt.minES[[2]], main="Min ES RB Risk Contribution",
                 risk.type="percentage")
dev.off()
# Plot the weights of portfolio 2 through time
png(paste(figures.dir, "weights_minESRB.png", sep="/"))
chart.Weights(bt.opt.minES[[2]], main="Min ES RB Weights")
dev.off()

# Plot the risk contribution  of portfolio 3 through time
png(paste(figures.dir, "risk_minESEqRB.png", sep="/"))
chart.RiskBudget(bt.opt.minES[[3]], main="Min ES EqRB Risk Contribution",
                 risk.type="percentage")
dev.off()
# Plot the weights of portfolio 3 through time
png(paste(figures.dir, "weights_minESEqRB.png", sep="/"))
chart.Weights(bt.opt.minES[[3]], main="Min ES EqRB Weights")
dev.off()

# Extract the returns from each element and chart the performance summary
ret.bt.opt <- do.call(cbind, lapply(bt.opt.minES, 
                                    function(x) summary(x)$portfolio_returns))
colnames(ret.bt.opt) <- c("min ES", "min ES RB", "min ES Eq RB")

png(paste(figures.dir, "ret_minES.png", sep="/"))
charts.PerformanceSummary(ret.bt.opt)
dev.off()

##### Example 4 #####
load(file=paste(results.dir, "opt.crra.rda", sep="/"))
load(file=paste(results.dir, "bt.opt.crra.rda", sep="/"))

CRRA <- function(R, weights, lambda, sigma, m3, m4){
  weights <- matrix(weights, ncol=1)
  M2.w <- t(weights) %*% sigma %*% weights
  M3.w <- t(weights) %*% m3 %*% (weights %x% weights)
  M4.w <- t(weights) %*% m4 %*% (weights %x% weights %x% weights)
  term1 <- 0.5 * lambda * M2.w
  term2 <- (1 / 6) * lambda * (lambda + 1) * M3.w
  term3 <- (1 / 24) * lambda * (lambda + 1) * (lambda + 2) * M4.w
  out <- -term1 + term2 - term3
  out
}

# Chart the optimization in Risk-Reward space
png(paste(figures.dir, "crra_RR_ES.png", sep="/"))
chart.RiskReward(opt.crra, risk.col="ES")
# dev.off()

png(paste(figures.dir, "crra_RR_StdDev.png", sep="/"))
chart.RiskReward(opt.crra, risk.col="StdDev")
dev.off()

# Compute the portfolio returns with rebalancing
ret.crra <- summary(bt.opt.crra)$portfolio_returns
colnames(ret.crra) <- "CRRA"

# Plot the performance summary of the returns from example 3 and CRRA
png(paste(figures.dir, "ret_crra.png", sep="/"))
charts.PerformanceSummary(cbind(ret.bt.opt, ret.crra), main="Optimization Performance")
dev.off()
