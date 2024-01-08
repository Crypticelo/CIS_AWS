library(sqldf)
library(ggplot2)

d=read.csv('/home/till/Ec2Instances/allec2.csv', sep=',')
d=sqldf("select * from d where name not like '%metal'")

## ram

d2=sqldf("
select cheap.proc proc, cheap.name n1, expen.name n2, expen.cost cost, expen.mem mem, (expen.mem-cheap.mem)/(expen.cost-cheap.cost) gbperdollar, (expen.cost-cheap.cost)/(expen.mem-cheap.mem) dollarpergb
from d cheap, d expen
where cheap.cpu = expen.cpu
and cheap.proc = expen.proc
and cheap.net = expen.net
and cheap.storage = expen.storage
and cheap.cost < expen.cost
and cheap.cost != expen.cost
and cheap.mem != expen.mem
order by gbperdollar
")

#pdf(width=12,height=7,pointsize=12, file="memory2.pdf")

ggplot(sqldf("select * from d2 where mem < 1024"), aes(mem, dollarpergb, color=proc)) +
    expand_limits(y=0) +
    geom_point() +
    theme_bw(20)

sqldf("
select proc, count(*) points, avg(dollarpergb) avg, min(dollarpergb), max(dollarpergb)
from d2
group by proc
order by avg
")


## cpu

d2=sqldf("
select cheap.proc proc, cheap.name n1, expen.name n2, expen.cpu cpu, (expen.cpu-cheap.cpu)/(expen.cost-cheap.cost) cpuperdollar, (expen.cost-cheap.cost)/(expen.cpu-cheap.cpu) dollarpercpu
from d cheap, d expen
where cheap.mem = expen.mem
and cheap.proc = expen.proc
and cheap.net = expen.net
and cheap.storage = expen.storage
and cheap.cost < expen.cost
order by cpuperdollar
")

#pdf(width=12,height=7,pointsize=12, file="cpus.pdf")

ggplot(d2, aes(cpu, dollarpercpu, color=proc)) +
    expand_limits(y=0) +
    geom_point() +
    theme_bw(20)

sqldf("
select * from d2
where proc = 'AMD EPYC 7R13 Processor'
")
## net

sqldf("
select cheap.proc, cheap.name, cheap.net, expen.name, expen.net, (expen.net-cheap.net)/(expen.cost-cheap.cost) netperdollar
from d cheap, d expen
where cheap.mem = expen.mem
and cheap.cpu = expen.cpu
and cheap.proc = expen.proc
and cheap.net != expen.net
and cheap.storage = expen.storage
and cheap.cost < expen.cost
and cheap.net not like 'Up to%'
and expen.net not like 'Up to%'
order by netperdollar
")



sqldf("
select proc, avg(dollarpercpu) avg, min(dollarpercpu), max(dollarpercpu)
from d2
group by proc
order by avg
")
