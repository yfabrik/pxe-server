@echo done
@set DelayInSeconds=10
@rem Use ping to wait
@ping 192.0.2.1 -n 1 -w %DelayInSeconds%000 > nul
