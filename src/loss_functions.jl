# Absolute Percentage Error
ape(yhat, y) = abs((y-yhat) ./ y)

# Median Absolute Percentage Error
medape(yhat, y) = 100.0 * median(ape(yhat, y))

# Mean Absolute Percentage Error
mape(yhat, y) = 100.0 * mean(ape(yhat, y))

# R2 is R squared which is how much more variation is explained by the 
# fitted values (yhat) compared to just using the mean as the model?
r2(yhat, y) = 1.0 - ( sum((y .- yhat).^2) / sum((y .- mean(y)).^2) )

# R2adj is R squared adjusted for the number of estimated variables K.
function r2adjusted(yhat, y, k)
  n = length(y)
  1.0 - ( (sum((y .- yhat).^2)/(n-k)) / (sum((y .- mean(y)).^2)/(n-1)) )
end

# Describe the goodness of fit in terms a user can easily digest.
# If k, the number of estimated variables of the model, is given we use
# R2adjusted instead of R2.
function describe_goodness_of_fit(yhat, y, k = false)
  if k != false
    @sprintf("MAPE = %.2f%%, R2adj = %.2f", mape(yhat, y), r2adjusted(yhat, y, k))
  else
    @sprintf("MAPE = %.2f%%, R2 = %.2f", mape(yhat, y), r2(yhat, y))
  end
end