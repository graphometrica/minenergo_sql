--таблица,содеражащая информация об энергопотреблении
create table minenergo.power
(
    datetime timestamp not null,
    "SubjectId" integer,
    "PowerSystemId" integer,
    "IBR_ActualConsumption" integer,
    "IBR_ActualGeneration" integer,
    "IBR_AveragePrice" integer,
    "IBR_PlannedConsumption" integer,
    "IBR_PlannedGeneration" integer,
    url varchar
);

alter table minenergo.power owner to graphometrica;

--удаление дефектных данных
delete from minenergo.power where "IBR_ActualConsumption" is null;

--группировка котировок на данные с энергопотреблением
create table minenergo.joined2
as
select p.datetime as ds, p."IBR_ActualConsumption" as y,p."SubjectId" as region, yd.oil, yd.al, yd.gas, yd.copper, yd.gazprom, yd.rusal, yd.rub, wh.middle_temp as temp
from minenergo.power as p
left join public.yahoo_finance_2 as yd on p.datetime::date::timestamp = yd."Date"
left join minenergo_schema.weather_history as wh on date_part('hour', p.datetime) = date_part('hour', wh.timestamp)
                                                        and date_part('day', p.datetime) = date_part('day', wh.timestamp)
    and date_part('month', p.datetime) = date_part('month', wh.timestamp) and wh.subject_id = p."SubjectId";


--удаление нулевых котировок
/*select count(*)*/ delete from minenergo.joined where oil is null;


--решение проблемы с 29 февраля
UPDATE minenergo.joined as nj
SET temp=subquery.temp
FROM (select (j1.temp + j2.temp)/2 as temp from minenergo.joined as j
                                                    left join minenergo.joined as j1 on j1.region = j.region and j1.ds = j.ds - interval '1 day'
                                                    left join minenergo.joined as j2 on j2.region = j.region and j2.ds = j.ds + interval '1 day'
      where j.temp is null) AS subquery
WHERE nj.temp is null;

--средняя температура по кварталам
insert into minenergo.q_temp
select extract(quarter from wh.timestamp), rd.power_system_id, avg(wh.middle_temp) from minenergo_schema.weather_history as wh
left join minenergo.minenergo_schema.region_directory as rd on wh.subject_id = rd.subject_id
group by rd.power_system_id, extract(quarter from wh.timestamp);