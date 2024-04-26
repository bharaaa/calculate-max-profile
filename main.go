package main

import "fmt"

func maxProfit(prices []int, k int) int {
	n := len(prices)
	if n <= 1 {
		return 0
	}

	if k >= n/2 {
		maxProfit := 0
		for i := 1; i < n; i++ {
			if prices[i] > prices[i-1] {
				maxProfit += prices[i] - prices[i-1]
			}
		}
		return maxProfit
	}

	dp := make([][]int, k+1)
	for i := range dp {
		dp[i] = make([]int, n)
	}

	for i := 1; i <= k; i++ {
		maxDiff := -prices[0]
		for j := 1; j < n; j++ {
			dp[i][j] = max(dp[i][j-1], prices[j]+maxDiff)
			maxDiff = max(maxDiff, dp[i-1][j]-prices[j])
		}
	}

	return dp[k][n-1]
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}

func main() {
	prices := []int{3, 4, 3, 4, 3, 3}
	transactions := 2
	fmt.Println("Maximum profit with", transactions, "transactions:", maxProfit(prices, transactions))
}
