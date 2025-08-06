import { createApp } from 'vue'
import App from './App.vue'
import { Button, Field, CellGroup, NavBar, Toast, Uploader, Card, Space, Loading, Cell } from 'vant'
import 'vant/lib/index.css'

const app = createApp(App)

app.use(Button)
app.use(Field)
app.use(CellGroup)
app.use(NavBar)
app.use(Toast)
app.use(Uploader)
app.use(Card)
app.use(Space)
app.use(Loading)
app.use(Cell)

app.mount('#app')
