{
    # i don't understand how this cursed algorithm works, but it works
    # (stripped form of Howard Hinnant's civil-from-days algorithm)
    timestampToDate =
        ts:
        let
            z = (ts / 86400) + 719468;
            era = (if z >= 0 then z else z - 146096) / 146097;
            doe = z - era * 146097;
            yoe = (doe - doe / 1460 + doe / 36524 - doe / 146096) / 365;
            y = yoe + era * 400;
            doy = doe - (365 * yoe + yoe / 4 - yoe / 100);
            mp = (5 * doy + 2) / 153;
            d = doy - (153 * mp + 2) / 5 + 1;
            m = mp + (if mp < 10 then 3 else -9);
            year = y + (if m <= 2 then 1 else 0);

            pad = n: if n < 10 then "0${toString n}" else toString n;
        in
        "${toString year}-${pad m}-${pad d}";
}
