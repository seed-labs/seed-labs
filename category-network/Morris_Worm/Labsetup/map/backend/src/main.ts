import express from 'express';
import expressWs from 'express-ws';

const app = express();
expressWs(app);

import apiV1Router from './api/v1/main';

app.use(express.static('../frontend/public'));
app.use('/api/v1', apiV1Router);

app.listen(8080, '0.0.0.0');