## Timekeep

This repository contains the back-end for **Timekeep**, a time-management app built with Elixir and Phoenix. Timekeep lets you create recurring time counters with specific goals, keeping you accountable and motivated to spend dedicated hours on any activity.

![Realme 10](https://github.com/user-attachments/assets/a49d1381-3a95-4eca-98d0-91027cc41cea)


## Usage

1. **Clone the repository**

   ```bash
   git clone https://github.com/your-username/timekeep-backend.git
   ```

2. **Navigate into the project**

   ```bash
   cd timekeep-backend
   ```

3. **Install Elixir dependencies**

   ```bash
   mix deps.get
   ```

4. **Set up the database**

   ```bash
   # Create, migrate, and seed the database
   mix ecto.setup
   ```

5. **Start the Phoenix server**

   ```bash
   mix phx.server
   ```

6. **Running in development**

   * By default, the server runs at `http://localhost:4000`.
   * Use `iex -S mix phx.server` for an interactive session.

7. **Running tests**

   ```bash
   mix test
   ```

---

Feel free to adjust any configuration in `config/dev.exs` or `config/test.exs` as needed. If you have questions, check out the [Phoenix Guides](https://hexdocs.pm/phoenix).
