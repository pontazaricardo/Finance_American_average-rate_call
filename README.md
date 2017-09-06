# Finance_American_average-rate_call

This program calculates the price of American-style arithmetic average-rate calls (ARO) based on the CRR binomial tree.

## Notes
1. The payoff function is max(average - *X*, 0). 
2. If the holder exercises early, then average means the average up to that node.

## Inputs and outputs
1. **Inputs:** *S* (stock price at time = 0), *X* (strike price), *t* (maturity in years), *s* (%) (annual volatility), *r* (%) (continuously compounded annual interest rate), *n* (number of periods), and *k* (number of states per node).
2. **Output:** Both delta and price of an American-style arithmetic average-rate (ARO) call. 

## How to use
In MatLab, just run the given file.

## Example
Suppose *S* = 100, *X* = 70, *t* = 2 (years), *s* = 20%, *r* = 5%, *n* = 40, and *k* = 5.
1. The price is about 36.308.
2. The delta is about 0.9515. 
