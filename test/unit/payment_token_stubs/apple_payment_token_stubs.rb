module ApplePaymentTokenStubs
  def apple_pay_token
    token = <<~TEXT
      {\"signature\":\"MEYCIQD/JoCQ2AMHS0o1bXH4BhfosEsndtXU0jBhXrlFRXqHVgIhAMbYV8JOR1ysS6rrV4vwF+S8/I0bBDytRMEdItlHkXEQ\",\"protocolVersion\":\"ECv1\",\"signedMessage\":\"{\\\"encryptedMessage\\\":\\\"tJUnNLW8HBaDS3w6Q959I0WdTbo3IE9P1TMAFb/OhAQoRhV+qaiwQ0GTOMI7Dmzl1bfaMnYBFh8yAbCw6RMnzK71AZLwwXkDknUpxwtU1QJds2k2SINjiuBrQyt4VpgBFjVAzV9SWlCW+Mm9qfqAzN4N4mFgsvNw0GDlbzgHpjHyjKev/HAH4Gk98bLjXh+cmG9pL9hk1NIooLZPJ4I5q34Ri1dChKIXoQRScBYYFXzt3tk4u8ykiqCqPydjAls3vujNceKKj0SIRaixlpJ+jRJgK04XL3OOe4EzHd476ElKSwVfg96t5Y/ScJ1lPav2FNiCIekHevyhyIIiN9Vun3OsZ6wSRkSWaIkeflsK2potCpb2MzAdAgc1qQIdqBc3x9x1aLS/jEKgPY/gA1gnAyrbb8Ol/RF8W0FCaCE/A/DqPY+YdH92sUHBuOgmarPPU4KhZkshF09cD6hFMKMZBezYgFikXQ\\\\u003d\\\\u003d\\\",\\\"ephemeralPublicKey\\\":\\\"BKX7sb9PXjbdL8GsfEzcAiVYkM+QBJXt/L2yGXHjyJM7+NO7SlyPyXe3wK6+ky16ujphhwRy10c73LPANrwPTXY\\\\u003d\\\",\\\"tag\\\":\\\"e7DeYqVtIKIEZWmXAvA5OTZ2HwPSxyfCyrAAn7XEbm4\\\\u003d\\\"}\"}
    TEXT
  end
end
