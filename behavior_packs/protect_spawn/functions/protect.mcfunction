# Встановлюємо режим пригоди (adventure) для всіх гравців у радіусі 500 блоків від спавну (0 100 0)
execute as @a at @s if entity @s[distance=..500] run gamemode adventure @s

# Віддаленіші гравці — виживання (survival)
execute as @a at @s unless entity @s[distance=..500] run gamemode survival @s
