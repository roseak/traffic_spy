
<h2 class="lead">Most Received Event: <%= @params[:most_received_event] %></h2>

<div class="list-group">
  <ul>
    <%= partial :'partials/event_button', collection: @params %>
  </ul>
</div>
