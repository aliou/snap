(module snap.view.view {require {size snap.view.size
                                 buffer snap.common.buffer
                                 window snap.common.window
                                 tbl snap.common.tbl
                                 register snap.common.register}})

(local group (vim.api.nvim_create_augroup :SnapView {:clear true}))

(fn layout [config]
  "Creates a view layout"
  (let [{: width : height : row : col} (config.layout)
        index (- config.index 1)
        border (* index size.border)
        padding (* index size.padding)
        total-borders (* (- config.total-views 1) size.border)
        total-paddings (* (- config.total-views 1) size.padding)
        has-views (> config.total-views 0)
        stacked? (and has-views (< width size.narrow-threshold))
        available-height (- height size.border size.border size.padding)
        results-height (if stacked? (math.floor (* available-height (- 1 size.view-width))) 0)
        view-alloc (if stacked?
                     (- available-height results-height total-borders total-paddings)
                     (- height total-borders total-paddings))
        sizes (if config.view-heights
                  (tbl.allocate-custom view-alloc config.view-heights)
                  (tbl.allocate view-alloc config.total-views))
        height (. sizes config.index)
        col-offset (math.floor (* width size.view-width))
        title (if (and config.view-config config.view-config.title)
                  config.view-config.title
                  :Preview)]
    {:width (if stacked? width (- width col-offset size.padding size.padding size.border))
     : height
     :row (if stacked?
            (let [results-row (if config.reverse (+ row size.border size.padding size.padding) row)]
              (+ results-row results-height size.border border padding))
            (+ row (tbl.sum (tbl.take sizes index)) border padding))
     :col (if stacked? col (+ col col-offset (* size.border 2) size.padding))
     :focusable false
     : title}))

(defn create [config]
  "Creates a view"
  (let [bufnr (buffer.create)
        layout-config (layout config)
        winnr (window.create bufnr layout-config)]
    (vim.api.nvim_set_option_value :cursorline false {:win winnr})
    (vim.api.nvim_set_option_value :cursorcolumn false {:win winnr})
    (vim.api.nvim_set_option_value :wrap false {:win winnr})
    (vim.api.nvim_set_option_value :winhl "Normal:SnapNormal,FloatBorder:SnapBorder" {:win winnr})

    (fn delete []
      (when (vim.api.nvim_win_is_valid winnr)
        (window.close winnr))
      (when (vim.api.nvim_buf_is_valid bufnr)
        (buffer.delete bufnr)))

    (fn update [view]
      (when (vim.api.nvim_win_is_valid winnr)
        (let [layout-config (layout config)]
          (window.update winnr layout-config)
          (vim.api.nvim_win_set_option winnr :cursorline true)
          (tset view :height layout-config.height)
          (tset view :width layout-config.width))))

    (local view {: update : delete : bufnr : winnr :width layout-config.width :height layout-config.height})

    (vim.api.nvim_create_autocmd
      :VimResized
      { : group :callback (fn [] (view:update)) })

    view))

