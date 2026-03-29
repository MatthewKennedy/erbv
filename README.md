# Erbv

Erbv (Encapsulated Ruby View Components) is a lightweight Rails engine that brings component-like encapsulation to standard Rails partials. It allows you to define scoped CSS and JavaScript directly inside your partials while ensuring that assets are only rendered once per page, regardless of how many times the component is used.

## Features

- **Scoped Styles**: Automatically generates unique CSS class names based on the partial's file path.
- **Asset Deduplication**: CSS and JS blocks are captured and rendered once in your layout, preventing redundancy.
- **Container Queries**: Built-in support for CSS Container Queries to make components truly responsive.
- **Zero Boilerplate**: No need for separate Ruby classes; just use the Rails partials you already know.

## Installation

Add this line to your application's Gemfile:

Ruby

```ruby
gem "erbv"
```

And then execute:

Bash

```bash
bundle install
```

## Setup

In your application layout (e.g., `app/views/layouts/application.html.erb`), add the `yield` calls for the captured assets within your `<head>` and at the bottom of the `<body>`:

Code snippet

```erb
<html>
  <head>
    <%= yield :erbv_css %>
  </head>
  <body>
    <%= yield %>

    <%= yield :erbv_js %>
  </body>
</html>
```

## Usage

## 1. Create a Component

Erbv components are standard Rails partials. Use the `erbv_*` helpers to define your styles, scripts, and HTML structure.

Code snippet

```erb
<%# app/views/components/_card.html.erb %>

<% erbv_css do %>
  <style>
    <%= erbv_component_base_selector %> {
      border: 1px solid #ccc;
      border-radius: 8px;
      padding: 1rem;
    }

    @container (width > 400px) {
      <%= erbv_component_base_selector %> {
        display: flex;
        gap: 1rem;
      }
    }
  </style>
<% end %>

<% erbv_js do %>
  <script> console.log("Card component loaded"); </script>
<% end %>

<%= erbv_html(tag: :div) do %>
  <h3><%= title %></h3>

  <div class="content">
    <%= yield %>
  </div>
<% end %>
```

## 2. Rendering the Component

Because they are partials, you use the standard Rails `render` helper.

#### Passing Data via Locals

Code snippet

```erb
<%= render "components/card", title: "Hello World" do %>
  <p>This is the card body.</p>
<% end %>
```

## How it Works

## Automatic Scoping

When you call `erbv_html`, Erbv looks at the virtual path of the partial. It generates a unique CSS class name like `.erbv--components--card`.

- `erbv_component_base_selector`: Returns this generated class name for use in your `<style>` tags.
- `erbv_html`: Wraps your content in a tag (default is `div`) with this generated class.

## Asset Management

- **Deduplication**: If you render the "Card" component 10 times on one page, Erbv will only output the CSS and JS blocks once into your layout's `:erbv_css` and `:erbv_js` slots.
- **Container Queries**: The `erbv_css` helper automatically adds `container-type: inline-size` to your component's base selector, enabling modern responsive design out of the box.

## Helper Reference

| **Helper**                        | **Description**                                              |
| --------------------------------- | ------------------------------------------------------------ |
| `erbv_html(tag: :div, **options)` | Wraps content in a container with the unique component class. |
| `erbv_css(&block)`                | Captures CSS. Only renders once per component type per request. |
| `erbv_js(&block)`                 | Captures JS. Only renders once per component type per request. |
| `erbv_component_base_selector`    | Returns the unique CSS selector (e.g., `.erbv--path--to--partial`). |

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
