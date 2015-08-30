/obj/royaljelly
	name = "royal jelly"
	desc = "A sack with a green liquid inside"
	icon = 'icons/mob/alien.dmi'
	icon_state = "jelly"
	var/growth = 0
	var/maxgrowth = 100
	var/health = 100
	var/ready = 0
	var/plasmapool = 0


/obj/royaljelly/attack_hand(user as mob)
	var/mob/living/carbon/alien/humanoid/alien = user
	if(!istype(alien))
		user << "\blue This is not for you."
		return
	if(alien.canUseJelly)
		if(alien.hasJelly)
			user << "\blue You already feel the effects of the royal jelly flowing through your veins."
			return
		alien.hasJelly = TRUE
		alien.visible_message("[alien] drinks the royal jelly.")
		user << "\blue You feel the effects of the royal jelly flowing through your veins."
		del(src)
		return


/obj/royaljelly/attack_paw(user as mob) //can be picked up by aliens
	if(isalien(user))
		attack_hand(user)
		return
	else
		..()
		return


/obj/royaljelly/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.damage
	if(health <= 0)
		del(src)
	return


/obj/royaljelly/New()
	//grow()
	var/matrix/M = matrix()
	M.Scale(1,1)
	src.transform = M

	..()