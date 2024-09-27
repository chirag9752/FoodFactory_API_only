Rails.configuration.stripe = {
  publishable_key: ENV["pk_test_51Q3ImL019tO9WYws4QgZexSyBogNbjG6D5Ognfg5D4BJ4jvqdvcHWPW7bPmExjUBrhn07RBsV6frJ4mLZSOWzvon00ntdxVVga"],
  secret_key: ENV["sk_test_51Q3ImL019tO9WYws6oQ11mzurSt9wTCGK50S1eFFhrhflWy90B14IckIdYWtrAQvqyw3LLqf2ah5lsnJhncFkiCw00628AtZri"]
}
Stripe.api_key = Rails.configuration.stripe[:secret_key]