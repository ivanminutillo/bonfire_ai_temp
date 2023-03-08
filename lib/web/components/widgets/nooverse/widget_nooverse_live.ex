defmodule Bonfire.AI.Web.WidgetNooverseLive do
  use Bonfire.UI.Common.Web, :stateful_component

  prop text, :string, default: nil
  prop prediction, :string, default: nil
  prop running?, :boolean, default: false
  prop serving, :any, default: nil
  prop label, :string, default: nil

  def update(assigns, socket) do
    {:ok,
    socket
    |> assign(assigns)
    |> assign(running?: false)
    |> assign(text: nil)
    |> assign(label: "nil")
    |> assign(prediction: nil)
    |> assign(serving: serving())
    |> assign(text: "I am so happy today!")}
  end

  def handle_event("start", _params, socket) do
    send(self(), :run)

    {:noreply, assign(socket, running?: true)}
  end

  def handle_info(:run, %{assigns: %{running?: true}} = socket) do
    {:ok, prediction} = predict(socket.assigns.serving, socket.assigns.text)
  end

  def handle_info(_msg, socket), do: {:noreply, socket}


  defp predict(serving, text) do
    res = Nx.Serving.run(serving, text)
  end

  defp serving do
    {:ok, model_info} = Bumblebee.load_model({:hf, "finiteautomata/bertweet-base-emotion-analysis"})
    {:ok, tokenizer} = Bumblebee.load_tokenizer({:hf, "vinai/bertweet-base"})


  end

end
