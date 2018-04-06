#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Iga tööpäeva hommikul tuleb kell 7:30 avada registreerimine. Teostada CRONiga.
from database import PGDatabase
import datetime

db = PGDatabase()
kuupaev = datetime.date.today().replace(day=1).strftime('%Y-%m-%d')
db.execute("""SELECT f_sulge_soogikorra_registreerimine(%s)""", "kuupaev")
