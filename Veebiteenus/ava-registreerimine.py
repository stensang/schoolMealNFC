#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Igal tööpäeval kell 7:00 tuleb avada registreerimine. Teostada CRONiga.
from database import PGDatabase
import datetime

db = PGDatabase()
kuupaev = datetime.date.today().strftime('%Y-%m-%d')
db.execute("""SELECT f_ava_soogikorra_registreerimine(%s)""", (kuupaev,))
db.commit()
db.close()
