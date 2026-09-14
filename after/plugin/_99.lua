local _99 = require("99")

local cwd = vim.uv.cwd()
local basename = vim.fs.basename(cwd)

local data_dir = vim.fn.stdpath("data") .. "/99"
local state_dir = vim.fn.stdpath("state") .. "/99"

vim.fn.mkdir(data_dir, "p")
vim.fn.mkdir(state_dir, "p")

_99.setup({
  provider = _99.Providers.ClaudeCodeProvider,
  model = "claude-opus-5-5",

  logger = {
    level = _99.DEBUG,
    path = "/tmp/" .. basename .. ".99.debug",
    print_on_error = true,
  },

  tmp_dir = data_dir .. "/tmp",

  completion = {
    source = "native",
  },

  md_files = {
    "AGENT.md",
  },
})

-- Заменить визуальное выделение результатом агента по промпту
vim.keymap.set("v", "<leader>9", function()
  _99.visual()
end, { desc = "99: заменить выделение" })

-- Остановить все текущие запросы и отбросить их результаты
vim.keymap.set("n", "<leader>9x", function()
  _99.stop_all_requests()
end, { desc = "99: остановить все запросы" })

-- Поиск по проекту: локации и заметки попадут в quickfix
vim.keymap.set("n", "<leader>9s", function()
  _99.search()
end, { desc = "99: поиск по проекту" })

-- Vibe-сессия у текущего провайдера (агент сам решает, что менять)
vim.keymap.set("n", "<leader>9b", function()
  _99.vibe()
end, { desc = "99: vibe-сессия" })

-- Открыть последний результат: quickfix для search/vibe, окно для tutorial
vim.keymap.set("n", "<leader>9o", function()
  _99.open()
end, { desc = "99: открыть последний результат" })

-- Показать логи выбранного запроса
vim.keymap.set("n", "<leader>9l", function()
  _99.view_logs()
end, { desc = "99: логи запросов" })

-- Очистить историю предыдущих visual/search-операций
vim.keymap.set("n", "<leader>9c", function()
  _99.clear_previous_requests()
end, { desc = "99: очистить историю запросов" })

-- Горячая клавиша плагина 99: сгенерировать tutorial (обучающий текст) по текущему контексту.
-- В normal mode: <leader>9t (у вас leader, скорее всего, пробел → пробел, затем 9, затем t).

-- Регистрация keymap в normal mode ("n") на комбинацию <leader>9t.
vim.keymap.set("n", "<leader>9t", function()
  -- Вызывает _99.tutorial(): плагин спросит тему (input «Tutorial»), соберёт контекст
  -- (текущий буфер, AGENT.md и др.), отправит запрос агенту (CursorAgentProvider,
  -- модель из setup) с промптом «напиши tutorial в Markdown; первая строка — заголовок».
  -- Ответ откроется в split-окне; повторно — <leader>9o (_99.open()).
  _99.tutorial()
end, { desc = "99: tutorial" }) -- подпись для which-key / :map

-- Показать статус: число запросов и кастомные правила
vim.keymap.set("n", "<leader>9i", function()
  _99.info()
end, { desc = "99: информация о сессии" })

-- Выбрать модель через Telescope
vim.keymap.set("n", "<leader>9m", function()
  require("99.extensions.telescope").select_model()
end, { desc = "99: выбрать модель" })

-- Выбрать провайдера через Telescope (модель сбросится на дефолт провайдера)
vim.keymap.set("n", "<leader>9p", function()
  require("99.extensions.telescope").select_provider()
end, { desc = "99: выбрать провайдера" })

-- Задать текущую задачу (work item) для Worker
vim.keymap.set("n", "<leader>9w", function()
  _99.Extensions.Worker.set_work()
end, { desc = "99: задать задачу" })

-- Найти, что ещё осталось сделать по текущей задаче
vim.keymap.set("n", "<leader>9W", function()
  _99.Extensions.Worker.search()
end, { desc = "99: поиск по задаче" })

-- Vibe-сессия по текущей задаче Worker
vim.keymap.set("n", "<leader>9B", function()
  _99.Extensions.Worker.vibe()
end, { desc = "99: vibe по задаче" })
