function dua --argument-names target
    if type gdu >/dev/null
        gdu -ahd1 $target | sort -h
    else
        du -sh $target/* | sort -h
    end
end
