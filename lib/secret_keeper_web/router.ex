defmodule SecretKeeperWeb.Router do
  use SecretKeeperWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :auth do
    plug(SecretKeeper.Auth.AuthAccessPipeline)
  end

  scope "/api", SecretKeeperWeb, as: :api do
    pipe_through(:api)

    scope "/v1", Api.V1, as: :v1 do
      post("/user/register", AuthModule.AuthController, :register)
      post("/user/login", AuthModule.AuthController, :login)
    end
  end

  scope "/api", SecretKeeperWeb, as: :api do
    pipe_through([:api, :auth])

    scope "/v1", Api.V1, as: :v1 do
      post("/user/logout", AuthModule.AuthController, :logout)
    end
  end
end
