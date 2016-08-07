defmodule ReverseProxy.ErrorViewTest do
  use ReverseProxy.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.json" do
    assert render(ReverseProxy.ErrorView, "404.json", []) ==
           %{errors: %{detail: "Page not found"}}
  end

  test "render 500.json" do
    assert render(ReverseProxy.ErrorView, "500.json", []) ==
           %{errors: %{detail: "Internal server error"}}
  end

  test "render any other" do
    assert render(ReverseProxy.ErrorView, "505.json", []) ==
           %{errors: %{detail: "Internal server error"}}
  end
end
